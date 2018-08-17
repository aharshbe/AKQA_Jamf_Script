require.config({
  baseUrl: 'https://s3-us-west-1.amazonaws.com/sfo.starthere/js/app',
    paths: {
        'jquery': 'https://s3-us-west-1.amazonaws.com/sfo.starthere/js/vendor/jquery/jquery.min',
        'insertionQuery': 'https://s3-us-west-1.amazonaws.com/sfo.starthere/js/vendor/insertionQuery.min'
    },
    map: {
      '*': { 'jquery': 'jquery-private' },
      'jquery-private': { 'jquery': 'jquery' }
    }
});

require(['main']);