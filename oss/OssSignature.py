#!/usr/bin/python
# argv[1] Access Key Secret(OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV)
# argv[2] method +\n\n\n + invalid time to_i +\n + store path(GET\n\n\n1141889120\n/oss-example/oss-api.pdf)
#http://oss-example.oss.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=44CF9590006BF252F707&Expires=1141889120&Signature=vjbyPxybdZaNmGa%2ByT272YEAiv4%3D

import sys
import sha
import urllib
import base64
import hmac

h = hmac.new(sys.argv[1],sys.argv[2],sha)
hash = urllib.quote_plus (base64.encodestring(h.digest()).strip())

print hash

