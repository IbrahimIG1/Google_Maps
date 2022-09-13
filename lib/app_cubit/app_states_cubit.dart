abstract class AppCubitStates {}

class InitialState extends AppCubitStates {}

//  request GPS Permission
class IsGpsStateSuccess extends AppCubitStates {}

// Get Position
class GetPositionLoadingState extends AppCubitStates {}

class GetPositionSuccessState extends AppCubitStates {}

class GetPositionErrorState extends AppCubitStates {}

// Get place Information
class GetPlaceInfoLoadingState extends AppCubitStates {}

class GetPlaceInfoSuccessState extends AppCubitStates {}

class GetPlaceInfoErrorState extends AppCubitStates {}

// Set Marker
class SetMarkerLoadingState extends AppCubitStates {}

class SetMarkerSuccessState extends AppCubitStates {}

class SetMarkerErrorState extends AppCubitStates {}
