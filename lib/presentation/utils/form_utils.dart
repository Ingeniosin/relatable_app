class FormUtils {
  static String? Function(String?) getValidator(List<Validator> validators) {
    return (value) {
      for (var validators in validators) {
        var isValid = validators.validate(value) ?? false;
        if (!isValid) {
          return validators.message;
        }
      }

      return null;
    };
  }
}

class Validator {
  final String message;
  final bool? Function(String?) validate;

  Validator(this.message, this.validate);
}
