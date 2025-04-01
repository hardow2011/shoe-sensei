module.exports = {
    plugins: [
        // https://github.com/MadLittleMods/postcss-css-variables to transform the css
        // variables to their static values for the emails
      require("postcss-css-variables")({
        preserve: false, // Set to false to replace variables with static values
      }),
    ],
  };
  