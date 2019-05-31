// For a detailed explanation regarding each configuration property, visit:
// https://jestjs.io/docs/en/configuration.html

module.exports = {
  collectCoverage: true,
  collectCoverageFrom: [
    '**/*.js',
    '!**/*.test.js'
  ],
  coverageDirectory: 'test-output',
  coverageReporters: [
    'text-summary',
    'cobertura'
  ],
  reporters: [
    'default',
    ['jest-junit', {
      suiteName: 'jest tests',
      outputDirectory: 'test-output',
      outputName: 'junit.xml'
    }]
  ],
  resetModules: true,
  restoreMocks: true,
  testEnvironment: 'node'
}
