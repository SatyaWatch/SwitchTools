from nintendo import switch
from anynet import tls
import re
import sys
import subprocess

#https://github.com/Kinnay/NintendoClients/issues/32

if len(sys.argv) >= 3:
    keyPath, prodInfoPath = sys.argv[1], sys.argv[2]
else:
    keyPath = input("enter prod.keys path: ")
    prodInfoPath = input("enter prodinfo.bin path: ")
    
def clean_path(p: str) -> str:
    return p.strip().strip('"').strip("'")

keyPath      = clean_path(keyPath)
prodInfoPath = clean_path(prodInfoPath)

keys = switch.load_keys(keyPath)
info = switch.ProdInfo(keys, prodInfoPath)

cert = info.get_tls_cert()
pkey = info.get_tls_key()

cert.save("device_cert.pem",tls.TYPE_PEM)
pkey.save("device_cert.key",tls.TYPE_PEM)