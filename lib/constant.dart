const baseURL = 'http://localhost:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const getAllUsersURL = baseURL + '/get-all-users';
const getUserPostURL = baseURL + '/get-user-posts';
const getUserAllPostURL = baseURL + '/get-user-all-posts';

const userPostURL = baseURL + '/posts';

const multipleImageURL = baseURL + '/multiple-image-upload';
const getImagesURL = baseURL + '/get-images';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
