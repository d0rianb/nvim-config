import { FlatCompat } from '@eslint/eslintrc'
import js from '@eslint/js'
import tsParser from '@typescript-eslint/parser'

const compat = new FlatCompat({
    baseDirectory: new URL('.', import.meta.url).pathname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all,
})

export default [
    // ...compat.extends('eslint:recommended'),
    {
        files: ['**/*.js', '**/*.jsx', '**/*.ts', '**/*.tsx'],
        languageOptions: {
            parser: tsParser,
            parserOptions: {
                ecmaVersion: 2022,
                sourceType: 'module',
            },
        },
        rules: {
            'newline-per-chained-call': ['error', { ignoreChainWithDepth: 1 }],
        },
    },
    ...compat.extends('prettier'),
]
