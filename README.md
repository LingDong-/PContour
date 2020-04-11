# PContour

*Java/[Processing](https://processing.org/) library for finding contours in binary images, made at [The Frank-Ratchye STUDIO for Creative Inquiry](https://studioforcreativeinquiry.org/) at CMU.*

### [Documentation](https://pcontour.netlify.com/reference/pcontour/pcontour) | [Website](https://pcontour.netlify.com/) | [Download](https://pcontour.netlify.com/download/PContour.zip)

![](web/gif.gif)

Similar to [OpenCV](https://opencv.org/)'s `cv::findContours` and `cv::approxPolyDP`, the algorithms implement the following papers:

- Suzuki, S. and Abe, K., *Topological Structural Analysis of Digitized Binary Images by Border Following* [[PDF](https://www.academia.edu/15495158/Topological_Structural_Analysis_of_Digitized_Binary_Images_by_Border_Following)]

- David Douglas and Thomas Peucker, *Algorithms for the reduction of the number of points required to represent a digitized line or its caricature* [[PDF](https://pdfs.semanticscholar.org/e46a/c802d7207e0e51b5333456a3f46519c2f92d.pdf?_ga=2.159056185.224903301.1586631312-1235308287.1586631312)]

The library is originally intended to be used with Processing, but should work for Java as well since it does not depend on Processing API.

## Motivation

I find OpenCV's `findContours` to be massively useful, and have used it to hammer almost all my computer-vision-related nails. However including the entire OpenCV library was not suitable for another Processing library project I'm working on. The original plan was to port OpenCV's implementation ([imgproc/src/contours.cpp](https://github.com/opencv/opencv/blob/master/modules/imgproc/src/contours.cpp)), but theirs was heavily oriented toward C/C++ memory managment and interwined with data structures from rest of the library. The lack of comments made it even more confusing. So I decided to reimplement from scratch the algorithm from the same paper on which the OpenCV impelmentation is based (Suzuki 85). 

I've commented every block of code with excerpts from the paper, explaining exactly what each step does. Since Java is a very generic and uninteresting language, it should be very easy to  port this implementation again to other languages. See `src/pcontour/PContour.java`.

## Installation

### For Processing

Download the [zip](https://pcontour.netlify.com/download/PContour.zip), unzip and put into the libraries folder of your Processing sketches. Reference and examples are included in the PContour folder.

### For Java

Download the [zip](https://pcontour.netlify.com/download/PContour.zip), unzip, and grab `PContour.jar`. Or, find all source code in `src/pcontour/PContour.java` and compile it the way you want.

### Building from source

Clone this repo, and follow the steps from [processing/processing-library-template](https://github.com/processing/processing-library-template).

## Usage

```java
import pcontour.*;

int[] bitmap = new int[]{
	0,0,0,0,0,0,0,0,
	0,0,0,0,1,1,0,0,
	0,1,1,1,1,1,0,0,
	0,1,1,0,0,1,1,0,
	0,1,1,0,0,1,1,0,
	0,1,1,1,1,1,0,0,
	0,0,0,1,1,0,0,0,
	0,0,0,0,0,0,0,0,
};

int width  = 8;
int height = 8;

// find contours
ArrayList<PContour.Contour> contours = new PContour().findContours(bitmap, width, height);

// simplify the polyline
for (int i = 0; i < contours.size(); i++){
	contours.get(i).points = new PContour().approxPolyDP(contours.get(i).points,1);
}

```

Check out the Processing demos in `examples/` folder, as well as see the [javadoc documentation](https://pcontour.netlify.com/reference/pcontour/pcontour) for more details.


<sub>This library is made possible with support from The Frank-Ratchye STUDIO for Creative Inquiry.</sub>