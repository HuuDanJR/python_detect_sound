import 'dart:math';

String getRandomString() {
  List<String> stringList = [
    "Kindly review and process the feedback. Thank you 👉👌",
    "Appreciate your valuable feedback! 🙌", 
    "Thank you for taking the time to share your thoughts with us. 👍",
    "Your feedback is highly appreciated. Thanks a bunch! 🌟",
    "Grateful for your feedback! It helps us improve. 😊",
    "Thanks a million for your insightful feedback! 🙏",
    "Your feedback is like a gift to us. Thank you! 🎁",
    "We're thankful for your feedback and eager to improve. 💬",
    "Heartfelt thanks for sharing your thoughts with us! 💖",
    "Your feedback is gold to us. Thank you so much! 🌟",
    "We appreciate the feedback – it means a lot to us! 🚀"
  ];

  // Generate a random index within the range of the list
  int randomIndex = Random().nextInt(stringList.length);

  // Return the randomly selected string
  return stringList[randomIndex];
}