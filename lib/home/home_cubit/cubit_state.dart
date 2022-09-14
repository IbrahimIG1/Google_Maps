abstract class HomeCubitState{}

class InitStateHome extends HomeCubitState{}

//  request GPS Permission
class IsGpsStateSuccess extends HomeCubitState {}

// Get Position
class GetPositionLoadingState extends HomeCubitState {}

class GetPositionSuccessHomeState extends HomeCubitState {}

class GetPositionErrorState extends HomeCubitState {}

// Get place Information
class GetPlaceInfoLoadingState extends HomeCubitState {}

class GetPlaceInfoSuccessState extends HomeCubitState {}

class GetPlaceInfoErrorState extends HomeCubitState {}

// Set Marker
class SetMarkerLoadingState extends HomeCubitState {}

class SetMarkerSuccessState extends HomeCubitState {}

class SetMarkerErrorState extends HomeCubitState {}

class MapMarkClicSuccessState extends HomeCubitState {}

