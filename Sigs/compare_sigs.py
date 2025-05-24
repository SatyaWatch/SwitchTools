import re
import sys
import subprocess

def normalize(signature: str) -> list:
    return re.findall(r'[0-9A-Fa-f]{2}', signature)

def wildcard(sig1: list, sig2: list) -> list:
    length = min(len(sig1), len(sig2))
    return [
        byte1.upper() if byte1.lower() == byte2.lower() else '??'
        for byte1, byte2 in zip(sig1[:length], sig2[:length])
    ]

def copy_to_clipboard(text: str) -> None:
    try:
        p = subprocess.Popen(['clip'], stdin=subprocess.PIPE, text=True)
        p.communicate(text)
    except Exception:
        pass

def main():
    if len(sys.argv) >= 3:
        raw1, raw2 = sys.argv[1], sys.argv[2]
    else:
        raw1 = input("enter first signature: ")
        raw2 = input("enter second signature: ")

    sig1 = normalize(raw1)
    sig2 = normalize(raw2)

    if len(sig1) != len(sig2):
        print("warning: sigs differ in length; truncating")
    
    result = wildcard(sig1, sig2)
    output = ' '.join(result)
    print("\nWILDCARD:")
    print(output)

    copy_to_clipboard(output)
    print("Copied to clipboard.")
    input("press enter to quit.")

if __name__ == "__main__":
    main()
