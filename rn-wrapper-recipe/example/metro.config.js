const path = require('path');
const { getDefaultConfig } = require('@react-native/metro-config');
const { withMetroConfig } = require('react-native-monorepo-config');
const pkg = require('../package.json');

const root = path.resolve(__dirname, '..');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = getDefaultConfig(__dirname);

// Watch the monorepo root so edits in the library are picked up
config.watchFolders = [root];

// Resolver tweaks for monorepo + Fabric codegen
config.resolver = {
  ...(config.resolver || {}),
  // Prefer React Native entry so Metro loads src (with codegen) over compiled lib
  resolverMainFields: ['react-native', 'browser', 'main'],
  // Prevent Metro from walking up and pulling duplicates
  disableHierarchicalLookup: true,
  // Resolve deps from app and workspace to keep a single tree
  nodeModulesPaths: [
    path.join(__dirname, 'node_modules'),
    path.join(root, 'node_modules'),
  ],
  // Keep your shim and map singletons and the local package
  extraNodeModules: {
    ...(config.resolver?.extraNodeModules || {}),
    // Map your library name to the repo root so Metro resolves the local package
    // (Make sure your library’s package.json has `"react-native": "./src/index.tsx"`)
    [pkg.name]: root,
    // Force singletons to avoid duplicate React/RN trees
    'react-native': path.join(__dirname, 'node_modules/react-native'),
    react: path.join(__dirname, 'node_modules/react'),
    scheduler: path.join(__dirname, 'node_modules/scheduler'),
    // Existing shim
    'react-native-safe-area-context': path.resolve(
      __dirname,
      'shims/react-native-safe-area-context'
    ),
  },
};

module.exports = withMetroConfig(config, {
  root,
  dirname: __dirname,
});
