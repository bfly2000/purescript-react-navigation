const path = require('path')
const webpack = require('webpack')
const fs = require('fs')

const isProd = process.env.NODE_ENV === 'production'

const plugins = [
    new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    }),
    new webpack.NamedModulesPlugin()
]

module.exports = {
    devtool: isProd
        ? 'hidden-source-map'
        : 'cheap-source-map',
    entry: path.join(__dirname, 'index.web.js'),
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'bundle.js',
        publicPath: '/',
        pathinfo: !isProd
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loaders: ['babel-loader?cacheDirectory=true']
            }, {
                // Most react-native libraries include uncompiled ES6 JS.
                test: /\.js$/,
                include: [
                    /node_modules\/react-native-/, /node_modules\/react-navigation/
                ],
                loader: 'babel-loader',
                query: {
                    cacheDirectory: true
                }
            }, {
                test: /\.purs$/,
                exclude: /node_modules/,
                use: {
                    loader: 'purs-loader',
                    options: {
                        src: [
                            'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'
                        ],
                        // bundle: isProd, bundleOutput: 'distbundle.js',
                        psc: 'psa',
                        package: isProd
                    }
                }
            }, {
                test: /\.(gif|jpe?g|png|svg)$/,
                loader: 'url-loader',
                query: {
                    name: '[name].[hash:16].[ext]'
                }
            }
        ]
    },
    plugins: plugins,
        resolve: {
        alias: {
            "react-native": "react-native-web/src",
            "react-navigation": "react-navigation/src/react-navigation.js"
        }
    },
    performance: {
        hints: false
    },
    devServer: {
        port: 8080,
        historyApiFallback: true,
        watchOptions: {
            aggregateTimeout: 300,
            poll: 1000
        },
        compress: true,
        inline: true,
        stats: 'minimal'
    }
}