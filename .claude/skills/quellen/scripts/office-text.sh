#!/bin/sh
# Prints the text of a PPTX (per slide), DOCX or XLSX without extra tools.  Usage: office-text.sh <file>
set -eu
exec /usr/bin/python3 -I - "$1" <<'PY'
import re, sys, zipfile
path = sys.argv[1]
z = zipfile.ZipFile(path)
def texts(xml):
    return [t for t in re.findall(r"<(?:a:t|w:t|t)(?:\s[^>]*)?>([^<]*)</(?:a:t|w:t|t)>", xml) if t.strip()]
names = z.namelist()
low = path.lower()
if low.endswith(".pptx"):
    slides = sorted((n for n in names if re.match(r"ppt/slides/slide\d+\.xml$", n)), key=lambda n: int(re.findall(r"\d+", n)[-1]))
    for n in slides:
        num = re.findall(r"\d+", n)[-1]
        print("--- slide " + num)
        print(" ".join(texts(z.read(n).decode("utf8"))))
        notes = n.replace("slides/slide", "notesSlides/notesSlide")
        if notes in names:
            print("  [notes] " + " ".join(texts(z.read(notes).decode("utf8"))))
elif low.endswith(".docx"):
    xml = z.read("word/document.xml").decode("utf8")
    for para in re.split(r"</w:p>", xml):
        line = "".join(texts(para))
        if line.strip():
            print(line)
elif low.endswith(".xlsx"):
    shared = texts(z.read("xl/sharedStrings.xml").decode("utf8")) if "xl/sharedStrings.xml" in names else []
    for n in sorted(x for x in names if re.match(r"xl/worksheets/sheet\d+\.xml$", x)):
        print(f"--- {n}")
        xml = z.read(n).decode("utf8")
        for ref, typ, val in re.findall(r'<c r="([A-Z]+\d+)"([^>]*)>(?:<f>[^<]*</f>)?<v>([^<]*)</v>', xml):
            print(ref, shared[int(val)] if 't="s"' in typ and val.isdigit() and int(val) < len(shared) else val)
else:
    sys.exit("unsupported file type (pptx, docx, xlsx)")
PY
