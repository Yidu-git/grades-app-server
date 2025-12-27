export const generateAPIKEY = async (length = 20) => {
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$%&";
  let API_KEY = "";

  for (let i = 0; i < length; i++) {
    API_KEY += characters.charAt(Math.floor(Math.random() * characters.length));
  }

  return API_KEY;
};
