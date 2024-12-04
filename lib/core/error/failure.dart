abstract class Failure {
  final String message;

  Failure(this.message);
}

class UnAvailableFailure extends Failure {
  UnAvailableFailure(super.message);
}

class UnClearCommandFailure extends Failure {
  UnClearCommandFailure(super.message);
}

class CameraFailure extends Failure {
  CameraFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
