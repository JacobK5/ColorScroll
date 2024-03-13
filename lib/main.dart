import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final Random random = Random();
  static final maxTillBlack = 150;

  // Function to generate a random color
  static Color getRandomColor(double? greyFactor) {
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    if (greyFactor != null) {
      // Calculate the grayscale value of the original color
      double gray = 0.2989 * r + 0.5870 * g + 0.1140 * b;

      // Interpolate between the original color and its grayscale equivalent
      r = (r + (gray - r) * greyFactor).toInt();
      g = (g + (gray - g) * greyFactor).toInt();
      b = (b + (gray - b) * greyFactor).toInt();

      // Decrease brightness by reducing the intensity towards a deeper gray,
      // ensuring it never reaches full black by setting a lower limit (e.g., 30)
      int minIntensity = 30; // The minimum intensity to prevent full black
      double brightnessFactor =
          1 - greyFactor * 0.7; // Adjust the 0.7 to control how dark it gets
      r = max((r * brightnessFactor).toInt(), minIntensity);
      g = max((g * brightnessFactor).toInt(), minIntensity);
      b = max((b * brightnessFactor).toInt(), minIntensity);
    }
    print('r: $r, g: $g, b: $b');
    return Color.fromRGBO(
      r,
      g,
      b,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          physics:
              const CustomScrollPhysics(), // Use the custom scroll physics here
          itemBuilder: (context, index) {
            // Generate a random color for each page
            print('index: $index');
            return Container(color: getRandomColor(index / maxTillBlack));
          },
        ),
      ),
    );
  }
}

// class ColorScrollPage extends StatelessWidget {
//   // Generate a list of random colors
//   final List<Color> colors = List.generate(100, (index) => getRandomColor());

//   ColorScrollPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: colors.length,
//       itemBuilder: (context, index) {
//         return Container(
//           color: colors[index],
//         );
//       },
//       // Use PageScrollPhysics for the snapping effect
//       physics: const PageScrollPhysics(),
//     );
//   }

// }

class CustomScrollPhysics extends PageScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Reduce the offset by a factor to slow down the scroll speed
    return super.applyPhysicsToUserOffset(
        position, offset * 0.5); // Adjust the factor as needed
  }

  // could maybe make these dynamic based on the current position and velocity or something but eh
  @override
  double get minFlingVelocity =>
      10; // Increase the threshold for fling velocity

  @override
  double get minFlingDistance =>
      50; // Increase the threshold for fling distance

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }
}
