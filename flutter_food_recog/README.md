# Food Recognition App

A sophisticated Flutter application that leverages the Google Gemini API to identify food items from images, and fetches comprehensive meal and nutritional data from external APIs.

## Key Features

* **Image Capture & Selection**: Utilizes the device's camera for real-time image capture or allows selection from the gallery.
* **Advanced Image Cropping**: Integrates an intuitive cropping tool to let users focus on the specific food item in an image.
* **AI-Powered Food Recognition**: Employs the Google Gemini API for highly accurate food identification directly from the image.
* **Detailed Meal Information**: Fetches comprehensive recipe details, including ingredients and step-by-step instructions, from TheMealDB API.
* **Nutritional Data Analysis**: Dynamically generates and displays key nutritional information (calories, protein, fat, etc.) for the identified food using the Google Gemini API.
* **Efficient State Management**: Built with the `provider` package for robust and scalable state management.
* **Modern and Responsive UI**: Features a clean, user-friendly interface that adapts to different screen sizes.

## Technology Stack

* **Framework**: Flutter
* **Language**: Dart
* **AI / Machine Learning**: Google Gemini API
* **External APIs**: TheMealDB API for meal recipes
* **State Management**: `provider`
* **Image Handling**: `camera`, `image_picker`, `image_cropper`
* **Permissions**: `permission_handler`
* **Environment Variables**: `envied`

## How It Works

The application follows a streamlined process to deliver a seamless user experience:

1.  **Image Input**: The user starts on the `HomePage` and chooses to either take a new photo or select one from their gallery.
2.  **Image Processing**: The `CameraProvider` manages the image source and presents a cropping interface using `image_cropper` for precise selection.
3.  **AI Recognition**: The cropped image is sent to the `FoodRecognitionProvider`. This provider sends the image data to the Google Gemini API, which returns the name of the identified food.
4.  **Data Fetching**: Once the food name is identified:
    * A request is sent to **TheMealDB API** to retrieve detailed recipe information, such as ingredients and cooking instructions.
    * A separate request is sent back to the **Google Gemini API** with the food name to generate a structured JSON object containing nutritional data.
5.  **Displaying Results**: The application navigates to the `ResultPage`, where it displays the user's image, the food's name, and the fetched recipe and nutritional information in a clear and organized layout.

## Prerequisites

* Flutter 3.32 or higher
* Dart 3.8.1 or higher
* Android SDK 21 or higher
* iOS 11.0 or higher
* A **Google Gemini API Key**.

## Setup and Installation

Follow these steps to get the project up and running on your local machine.

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/flutter_food_recog.git
    cd flutter_food_recog
    ```

2.  **Create `.env` File**
    This project requires an API key from Google Gemini. Create a file named `.env` in the root of the project directory and add your API key as follows:
    ```
    GEMINI_API_KEY=YOUR_API_KEY_HERE
    ```

3.  **Install Dependencies**
    Run the following command to fetch all the required packages:
    ```bash
    flutter pub get
    ```

4.  **Run the Build Runner**
    This command generates the necessary code for the environment variables.
    ```bash
    flutter pub run build_runner build -d
    ```

5.  **Run the App**
    Launch the application on your preferred device or simulator:
    ```bash
    flutter run
    ```

## Permissions Required

The application requests the following permissions to function correctly:

* **Camera**: To allow users to take photos of food items.
* **Storage/Photos**: To allow users to select images from their device's gallery.
* **Internet**: To communicate with the Google Gemini and TheMealDB APIs.

## Project Structure

The project follows a clean, feature-first architecture to separate concerns and improve maintainability.

```
lib/
├── core/
│   ├── providers/
│   │   ├── camera_provider.dart        # Manages camera, gallery, and cropping
│   │   └── food_recognition_provider.dart # Handles API calls and data processing
│   ├── routes/
│   │   └── app_router.dart           # Defines navigation routes
│   ├── theme/
│   │   └── app_theme.dart            # Defines app themes
│   └── utils/
│       ├── env.dart                  # Handles environment variables
│       ├── permission.dart           # Manages runtime permissions
│       └── snackbar_utils.dart       # Utility for showing snackbars
├── features/
│   ├── home/
│   │   └── presentation/pages/home_page.dart # App's entry screen
│   ├── camera/
│   │   └── presentation/pages/camera_page.dart # Camera interface screen
│   └── result/
│       └── presentation/pages/result_page.dart # Displays recognition results
└── main.dart                           # Main entry point of the application
```



## Contributing

Contributions are welcome! If you'd like to improve the app, please follow these steps:

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

## Acknowledgments

* **Google Gemini API** for the powerful image recognition and data generation capabilities.
* **TheMealDB API** for providing a free and comprehensive database of meal recipes.
* The **Flutter** team for their amazing cross-platform framework.