module.exports = {
  dependency: {
    platforms: {
      ios: {},
      android: {
        sourceDir: './android',
        packageImportPath: 'import com.rnwrap.RnWrapViewPackage;',
        packageInstance: 'new RnWrapViewPackage()',
      },
    },
  },
};
