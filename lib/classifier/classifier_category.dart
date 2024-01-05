// Class definition for a classification category
class ClassifierCategory {
  // String label representing the category
  final String label;

  // Double score representing the confidence score of the category
  final double score;

  // Constructor for the ClassifierCategory class
  ClassifierCategory(this.label, this.score);

  // Override toString method for better representation when converted to a string
  @override
  String toString() {
    return 'Category{label: $label, score: $score}';
  }
}
