#!/usr/bin/env python

__all__ = ['tudou_download', 'tudou_download_playlist', 'tudou_download_by_id', 'tudou_download_by_iid']

from common import *

def tudou_download_by_iid(iid, title, merge=True):
	xml = get_html('http://v2.tudou.com/v?it=' + iid + '&st=1,2,3,4,99')

	from xml.dom.minidom import parseString
	doc = parseString(xml)
	title = title or doc.firstChild.getAttribute('tt') or doc.firstChild.getAttribute('title')
	urls = [(int(n.getAttribute('brt')), n.firstChild.nodeValue.strip()) for n in doc.getElementsByTagName('f')]

	url = max(urls, key=lambda x:x[0])[1]
	assert 'f4v' in url

	#url_save(url, filepath, bar):
	download_urls([url], title, 'flv', total_size=None, merge=merge)

def tudou_download_by_id(id, title, merge=True):
	html = get_html('http://www.tudou.com/programs/view/%s/' % id)
	iid = r1(r'iid\s*=\s*(\S+)', html)
	tudou_download_by_iid(iid, title, merge=merge)

def tudou_download(url, merge=True):
	html = get_decoded_html(url)
	iid = r1(r'iid\s*[:=]\s*(\d+)', html)
	assert iid
	title = r1(r"kw\s*[:=]\s*'([^']+)'", html)
	assert title
	title = unescape_html(title)
	tudou_download_by_iid(iid, title, merge=merge)

def parse_playlist(url):
	#if r1('http://www.tudou.com/playlist/p/a(\d+)\.html', url):
	#	html = get_html(url)
	#	print re.search(r'<script>var.*?</script>', html, flags=re.S).group()
	#else:
	#	raise NotImplementedError(url)
	raise NotImplementedError()

def parse_playlist(url):
	aid = r1('http://www.tudou.com/playlist/p/a(\d+)(?:i\d+)?\.html', url)
	html = get_decoded_html(url)
	if not aid:
		aid = r1(r"aid\s*[:=]\s*'(\d+)'", html)
	if re.match(r'http://www.tudou.com/albumcover/', url):
		atitle = r1(r"title\s*:\s*'([^']+)'", html)
	elif re.match(r'http://www.tudou.com/playlist/p/', url):
		atitle = r1(r'atitle\s*=\s*"([^"]+)"', html)
	else:
		raise NotImplementedError(url)
	assert aid
	assert atitle
	import json
	#url = 'http://www.tudou.com/playlist/service/getZyAlbumItems.html?aid='+aid
	url = 'http://www.tudou.com/playlist/service/getAlbumItems.html?aid='+aid
	return [(atitle + '-' + x['title'], str(x['itemId'])) for x in json.loads(get_html(url))['message']]

def tudou_download_playlist(url, create_dir=False, merge=True):
	if create_dir:
		raise NotImplementedError('please report a bug so I can implement this')
	videos = parse_playlist(url)
	for i, (title, id) in enumerate(videos):
		print 'Downloading %s of %s videos...' % (i + 1, len(videos))
		tudou_download_by_iid(id, title, merge=merge)

download = tudou_download
download_playlist = tudou_download_playlist

def main():
	script_main('tudou', tudou_download, tudou_download_playlist)

if __name__ == '__main__':
	main()

