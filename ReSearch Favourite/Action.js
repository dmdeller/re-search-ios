//
//  Action.js
//  Re-Search: Favourite
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments)
    {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        arguments.completionFunction({"url": window.location.href});
    },
    
    finalize: function(arguments)
    {
        // This method is run after the native code completes.
        
        var newURL = arguments['newURL'];
        if (newURL)
        {
            window.location.href = newURL;
        }
        
        var error = arguments['error'];
        if (error)
        {
            alert(error);
        }
    }
};
    
var ExtensionPreprocessingJS = new Action;
