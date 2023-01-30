from PIL import Image
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
import os
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)

for filename in os.listdir('sprite_originals/'):
    filename = filename[:-4]
    new_w, new_h = 32, 32
    palette_hex = ['0x000000', '0xfcfefc', '0x444444', '0x666666', '0xcbcdcc', '0xdd6666', '0xff8888', '0x9a6543', '0x794422', '0xddab88', '0xff6000', '0xaaccaa', '0xcceecc', '0x90ffff', '0x8787b9', '0xceccfe']
    palette_rgb = [hex_to_rgb(color) for color in palette_hex]

    pixel_tree = KDTree(palette_rgb)
    im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
    im = im.convert("RGBA")
    layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
    layer.paste(im, (0, 0))
    im = layer
    #im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
    pix = im.load()
    pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
    pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
    pix_freqs_sorted.reverse()
    print(pix)
    outImg = Image.new('RGB', im.size, color='white')
    outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
    i = 0
    for y in range(im.size[1]):
        for x in range(im.size[0]):
            pixel = im.getpixel((x,y))
            print(pixel)
            if(pixel[3] < 200):
                outImg.putpixel((x,y), palette_rgb[0])
                outFile.write("%x\n" %(0))
                print(i)
            else:
                index = pixel_tree.query(pixel[:3])[1]
                outImg.putpixel((x,y), palette_rgb[index])
                outFile.write("%x\n" %(index))
            i += 1
    outFile.close()
    outImg.save("./sprite_converted/" + filename + ".png" )
