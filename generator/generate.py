"""Generate 24x24 pixel-art PNGs + metadata by layering random traits."""
import json
import random
from pathlib import Path

from PIL import Image

LAYERS = ["background", "body", "eyes", "hat"]
TRAITS = Path("layers")
OUT = Path("output")


def pick(layer, rng):
    options = sorted((TRAITS / layer).glob("*.png"))
    # files are named like "red_20.png" -> trait "red" with weight 20
    weights = [int(p.stem.rsplit("_", 1)[1]) for p in options]
    return rng.choices(options, weights)[0]


def main(n=1000, seed=2021):
    rng = random.Random(seed)
    (OUT / "images").mkdir(parents=True, exist_ok=True)
    (OUT / "metadata").mkdir(parents=True, exist_ok=True)
    seen = set()
    i = 1
    while i <= n:
        picks = {layer: pick(layer, rng) for layer in LAYERS}
        key = tuple(p.name for p in picks.values())
        if key in seen:
            continue
        seen.add(key)
        img = Image.new("RGBA", (24, 24))
        for p in picks.values():
            img.alpha_composite(Image.open(p).convert("RGBA"))
        img.resize((480, 480), Image.NEAREST).save(OUT / "images" / f"{i}.png")
        meta = {
            "name": f"PixelPal #{i}",
            "image": f"ipfs://IMAGES_CID/{i}.png",
            "attributes": [
                {"trait_type": layer, "value": p.stem.rsplit("_", 1)[0]}
                for layer, p in picks.items()
            ],
        }
        (OUT / "metadata" / f"{i}.json").write_text(json.dumps(meta, indent=2))
        i += 1


if __name__ == "__main__":
    main()
