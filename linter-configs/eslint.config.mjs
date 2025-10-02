import { FlatCompat } from '@eslint/eslintrc'
import js from '@eslint/js'
import tsParser from '@typescript-eslint/parser'

import globals from 'globals'

const compat = new FlatCompat({
  baseDirectory: new URL('.', import.meta.url).pathname,
  recommendedConfig: js.configs.recommended,
  allConfig: js.configs.all,
})

export default [
  // ...compat.extends('eslint:recommended'),
  {
    ignores: ['node_modules/**', 'dist/**', 'build/**', '**/*.min.js'],
    files: ['**/*.js', '**/*.jsx', '**/*.ts', '**/*.tsx'],

    languageOptions: {
      parser: tsParser,
      globals: {
        ...globals.browser,
        ...globals.node,
      },
      parserOptions: {
        ecmaVersion: 2022,
        sourceType: 'module',
      },
    },
    rules: {
      'newline-per-chained-call': ['error', { ignoreChainWithDepth: 1 }],
      'no-unused-vars': 'off',
    },
  },
  ...compat.extends('prettier'),
]
