#!/usr/bin/env python

__all__ = ['iqiyi_download']

import re
from common import *

def real_url(url):
	import time
	import json
	return json.loads(get_html(url[:-3]+'hml?v='+str(int(time.time()) + 1921658928)))['l'] # XXX: what is 1921658928?

def iqiyi_download(url, merge=True):
	html = get_html(url)
	#title = r1(r'title\s*:\s*"([^"]+)"', html)
	#title = unescape_html(title).decode('utf-8')
	#videoId = r1(r'videoId\s*:\s*"([^"]+)"', html)
	#pid = r1(r'pid\s*:\s*"([^"]+)"', html)
	#ptype = r1(r'ptype\s*:\s*"([^"]+)"', html)
	#info_url = 'http://cache.video.qiyi.com/v/%s/%s/%s/' % (videoId, pid, ptype)
	videoId = r1(r'''videoId\s*[:=]\s*["']([^"']+)["']''', html)
	assert videoId
	info_url = 'http://cache.video.qiyi.com/v/%s' % videoId
	info_xml = get_html(info_url)

	from xml.dom.minidom import parseString
	doc = parseString(info_xml)
	title = doc.getElementsByTagName('title')[0].firstChild.nodeValue
	size = int(doc.getElementsByTagName('totalBytes')[0].firstChild.nodeValue)
	urls = [n.firstChild.nodeValue for n in doc.getElementsByTagName('file')]
	assert urls[0].endswith('.f4v'), urls[0]
	urls = map(real_url, urls)
	download_urls(urls, title, 'flv', total_size=size, merge=merge)

download = iqiyi_download
download_playlist = playlist_not_supported('iqiyi')

def main():
	script_main('iqiyi', iqiyi_download)

if __name__ == '__main__':
	main()



