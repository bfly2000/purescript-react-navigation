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
    entry: [
        // activate HMR for React 'react-hot-loader/patch', bundle the client for
        // webpack-dev-server and connect to the provided endpoint
        'webpack-dev-server/client?http://localhost:8080',
        // bundle the client for hot reloading only- means to only hot reload for
        // successful updates
        'webpack/hot/only-dev-server',
        path.join(__dirname, 'index.web.js')
    ],
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'bundle.js' ,
        publicPath: '/',
        pathinfo: !isProd
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules|bower_components/,
                use: {
                    loader: 'babel-loader'
                }
            }, {
                test: /.purs$/,
                exclude: /node_modules/,
                use: {
                    loader: 'purs-loader',
                    options: {
                       src: [
                            'bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'
                        ],
                        bundle: isProd,
                        bundleOutput: 'dist/bundle.js',
                        psc: 'psa',
                        package: isProd,
                        watch: !isProd
                    }
                }
            }
        ]
    },
    plugins: plugins,
    resolveLoader: {
        modules: [path.join(__dirname, 'node_modules')]
    },
    resolve: {
        alias: {
            "react-native": "react-native-web"
        },
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