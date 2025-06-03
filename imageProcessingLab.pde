PImage original;
PImage img;

void settings() {
  original = loadImage("flowers.jpg");
  // resize the width to 300 and make sure the aspect ratio is the same
  original.resize(300, 0);
  img = original;
  // set the size so that the popup will fit a 3x3 grid of images
  size(img.width * 3, img.height * 3);
}

void gallery() {
  int cols = 3;
  int cellWidth = img.width;
  int cellHeight = img.height;

  for (int i = 0; i < 9; i++) {
    int x = (i % cols) * cellWidth;
    int y = (i / cols) * cellHeight;

    PImage result = img;

    // call each image processing method
    switch (i) {
      case 0:
        result = brighten(img, map(mouseX, 0, width, 0, 5));
        break;
      case 1:
        result = negative(img);
        break;
      case 2:
        result = binarize(img, map(mouseX, 0, width, 0, 255));
        break;
      case 3:
        result = posterize(img, int(map(mouseX, 0, width, 1, 255)));
        break;
      case 4:
        result = quantize(img, int(map(mouseX, 0, width, 1, 100)));
        break;
      case 5:
        result = soften(img);
        break;
      case 6:
        result = verticalFlip(img);
        break;
      case 7:
        result = rotateClockwise(img);
        break;
      case 8:
        result = shrink(img);
        break;
    }

    result.resize(cellWidth, cellHeight);
    image(result, x, y);
  }
}


// Brighten the image by a given factor
PImage brighten(PImage original, float factor) {
  PImage result = createImage(original.width, original.height, RGB);
  original.loadPixels();
  result.loadPixels();
  for (int i = 0; i < original.pixels.length; i++) {
    color c = original.pixels[i];
    float r = red(c) * factor;
    float g = green(c) * factor;
    float b = blue(c) * factor;
    result.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  result.updatePixels();
  return result;
}

// Set pixels to black and white based on a threshold
PImage binarize(PImage src, float threshold) {
  PImage result = createImage(src.width, src.height, RGB);
  result.loadPixels();
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      color old = src.get(x, y);
      float r = red(old);
      float g = green(old);
      float b = blue(old);

      float brightness = (r + g + b) / 3;

      if (brightness > threshold) {
        result.set(x, y, color(255));
      } else {
        result.set(x, y, color(0));
      }
    }
  }
  result.updatePixels();
  return result;
}

// Invert the image colors
PImage negative(PImage src) {
  PImage result = createImage(src.width, src.height, RGB);
  result.loadPixels();
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      color old = src.get(x, y);
      float r = red(old);
      float g = green(old);
      float b = blue(old);

      color newC = color(255 - r, 255 - g, 255 - b);
      result.set(x, y, newC);
    }
  }
  result.updatePixels();
  return result;
}

// Reduce the color depth of the image by a given factor
PImage posterize(PImage src, int multiple) {
  PImage result = createImage(src.width, src.height, RGB);
  result.loadPixels();
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      color old = src.get(x, y);
      float r = red(old);
      float g = green(old);
      float b = blue(old);
      float newR = int(r / multiple) * multiple;
      float newG = int(g / multiple) * multiple;
      float newB = int(b / multiple) * multiple;

      result.set(x, y, color(newR, newG, newB));
    }
  }
  result.updatePixels();
  return result;
}

// Flip the image vertically
PImage verticalFlip(PImage src) {
  PImage result = createImage(src.width, src.height, RGB);
  result.loadPixels();
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      color newC = src.get(x, src.height - 1 - y);

      result.set(x, y, newC);
    }
  }
  result.updatePixels();
  return result;
}

// Rotate the image clockwise 90 degrees and change the canvas size
PImage rotateClockwise(PImage source) {
  PImage result = createImage(source.height, source.width, RGB);
  result.loadPixels();

  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      color c = source.get(x, y);
      int newXVal = source.height - 1 - y;
      int newYVal = x;
      result.set(newXVal, newYVal, c);
    }
  }

  result.updatePixels();
  return result;
}

// Reduce the number of colors to n in the image and randomly assign the colors
PImage quantize(PImage source, int n) {
  color[] result = new color[n];

  for (int i = 0; i < n; i++) {
    result[i] = color(random(256), random(256), random(256));
  }

  PImage newImg = createImage(source.width, source.height, RGB);
  newImg.loadPixels();

  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      color c = source.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);

      float minDist = Float.MAX_VALUE;
      color closest = result[0];

      for (int i = 0; i < n; i++) {
        float newRed = red(result[i]);
        float newGreen = green(result[i]);
        float newBlue = blue(result[i]);

        float dist = distSquared(r, g, b, newRed, newGreen, newBlue);
        if (dist < minDist) {
          minDist = dist;
          closest = result[i];
        }
      }
      newImg.set(x, y, closest);
    }
  }

  newImg.updatePixels();
  return newImg;
}

// Helper method for squared distance between two colors
float distSquared(float rOld, float gOld, float bOld, float rNew, float gNew, float bNew) {
  return sq(rOld - rNew) + sq(gOld - gNew) + sq(bOld - bNew);
}

// Shrink the image to half of its size and center in the canvas
PImage shrink(PImage source) {
  int newWidth = source.width / 2;
  int newHeight = source.height / 2;
  PImage result = createImage(source.width, source.height, RGB);
  result.loadPixels();

  int offsetX = (source.width - newWidth) / 2;
  int offsetY = (source.height - newHeight) / 2;

  for (int y = 0; y< newHeight; y++) {
    for (int x = 0; x < newWidth; x++) {
      color c = source.get(x * 2, y * 2);
      result.set(offsetX + x, offsetY + y, c);
    }
  }
  result.updatePixels();
  return result;
}

// Soften the image by averaging neighboring pixels
PImage soften(PImage source) {
  int radius = 4;
  PImage result = createImage(source.width, source.height, RGB);
  result.loadPixels();

  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++) {
      int countUsed = 0;
      float rSum = 0, gSum = 0, bSum = 0;

      for (int dx = -radius; dx <= radius; dx++) {
        for (int dy = -radius; dy <= radius; dy++) {
          int nx = x + dx;
          int ny = y + dy;

          if (nx >= 0 && nx < source.width && ny >= 0 && ny < source.height) {
            color neighbor = source.get(nx, ny);
            rSum += red(neighbor);
            gSum += green(neighbor);
            bSum += blue(neighbor);
            countUsed++;
          }
        }
      }

      color c = color(rSum / countUsed, gSum / countUsed, bSum / countUsed);
      result.set(x, y, c);
    }
  }

  result.updatePixels();
  return result;
}

void draw() {
  //float amt = map(mouseX, 0, width, 0, 255);
  //PImage brightVersion = brighten(img, amt);
  //PImage negativeVersion = binarize(img, amt);
  //PImage result = rotate180(img);
  //image(negativeVersion, 0, 0);
  //float threshold = map(mouseX, 0, width, 0, 150);

  //lab
  //1
  //PImage result = brighten(img, 2);
  //2
  //PImage result = negative(img);
  //3
  //PImage result = binarize(img, 100);
  //4
  //int multiple = int(map(mouseX, 0, width, 0, 255));
  //PImage result = posterize(img, multiple);
  //5
  //PImage result = verticalFlip(img);
  //6
  //PImage result = rotateClockwise(img);
  //7
  //PImage result = quantize(img, 4);
  //8
  //PImage result = shrink(img);
  //9
  //PImage result = soften(img);
  //image(result, 0, 0);
  background(255);
  gallery();
}
