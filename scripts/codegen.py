# /// script
# requires-python = ">=3.13"
# dependencies = ["requests>=2.33.0"]
# ///

import time

import requests

faces = []

# get array of face asset ids
with open("faces.csv", mode="r") as faces_file:
    for row in faces_file:
        faces.append(row.strip())

bundle_face_dict = {}

for face in faces:
    delay = 1.0
    for attempt in range(5):
        try:
            response = requests.get(url=f"https://roblox.com/catalog/{face}")
            break
        except requests.exceptions.ConnectionError:
            if attempt == 4:
                raise
            print(f"Connection error for face {face}, retrying in {delay}s...")
            time.sleep(delay)
            delay *= 2
    else:
        bundle_face_dict[face] = None
        continue

    # some faces don't have bundles
    redirected_to_bundle = any(
        r.status_code == 302 and "/bundles/" in r.headers.get("Location", "")
        for r in response.history
    )
    if redirected_to_bundle:
        bundle_id = response.url.split("/")[4]
    else:
        bundle_id = None
    bundle_face_dict[face] = bundle_id
    time.sleep(1.0)

lines = ["local faceByBundle: {[number]: number} = {"]
for face, bundle_id in bundle_face_dict.items():
    if bundle_id is not None:
        lines.append(f"\t[{bundle_id}] = {face},")
lines.append("}")
lines.append("")
lines.append("return faceByBundle")

with open("../src/faceByBundle.luau", mode="w") as f:
    f.write("\n".join(lines) + "\n")

mesh_face_dict = {}

for face, bundle_id in bundle_face_dict.items():
    if bundle_id is None:
        continue
    delay = 1.0
    for attempt in range(5):
        try:
            response = requests.get(url=f"https://catalog.roblox.com/v1/bundles/{bundle_id}/details")
            if response.status_code == 429:
                print(f"Rate limited on bundle {bundle_id}, retrying in {delay}s...")
                time.sleep(delay)
                delay *= 2
                continue
            response.raise_for_status()
            break
        except requests.exceptions.ConnectionError:
            if attempt == 4:
                raise
            print(f"Connection error for bundle {bundle_id}, retrying in {delay}s...")
            time.sleep(delay)
            delay *= 2
    else:
        print(f"Skipping bundle {bundle_id} after 5 attempts")
        continue

    details = response.json()
    head_item = next(
        (item for item in details["items"] if item["type"] == "Asset" and "- Head" in item["name"]),
        None,
    )
    if head_item is not None:
        mesh_face_dict[head_item["id"]] = face
    time.sleep(1.0)

lines = ["local faceByMesh: {[number]: number} = {"]
for mesh_id, face in mesh_face_dict.items():
    lines.append(f"\t[{mesh_id}] = {face},")
lines.append("}")
lines.append("")
lines.append("return faceByMesh")

with open("../src/faceByMesh.luau", mode="w") as f:
    f.write("\n".join(lines) + "\n")
