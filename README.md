NOT FULLY WORKING YET, WORK IN PROGRESS
==========


Apidok
==========

Apidok is based on Swagger UI, part of [Swagger](http://swagger.wordnik.com/) project. The Swagger project allows you to produce, visualize and consume your OWN RESTful
services.  No proxy or 3rd party services required.  Do it your own way.

Swagger UI (adapted inside Apidok), is a dependency-free collection of HTML, Javascript, and CSS assets that dynamically 
generate beautiful documentation and sandbox from a [Swagger-compliant](https://github.com/wordnik/swagger-core/wiki) API. Because Swagger UI has no
dependencies, you can host it in any server environment, or on your local machine.

Apidok improves the way to document your REST API, key features are:

* Using npm instead of cake
* Retrocompatibility with Swagger UI (output generated files are made to be used directly with Swagger UI)
* Documentation written in CoffeeScript
* Documentation is simplified compared to raw Swagger files
* Inheritence for models (model can be extend from other model, if for example depending on calls, the response is not totaly the same)
* Easiest track of api versions ( http://api.doc/v2.1/resources.json)
* Adding role supports. Define some roles, add constraints over those roles, each role will have a optimized documentation. For instance, a user and a manager may not have the same access to the api, it's possible to hide some operations in the user doc: http://api.doc/v2.1/user/resources.json
* Soon... Rdoc compatibility ;)


How to
-------------

### Preparation

1. Install [node.js](http://nodejs.org)
2. On your system execute following commands (Unix)

```bash
git clone git@github.com:Tronix117/apidok.git
cd apidok
npm install
```

Apidok is now ready to use !!

### Document

In a folder, document your api using the same structure you can find in the `example` folder. Checkout [Swagger Spec](https://github.com/wordnik/swagger-core/wiki) for more advanced stuff.

### Generate

Go to the apidok directory and run `bin/apidok dist`

By default the documentation will be retrieve from the 'doc' folder and the generated website will be in 'dist'

You can find more option to the `apidok` script in the *apidok command* section

### Use

You can now directly open the index.html in the `dist` folder, and you will get your documentation! You can then, host that wherever you want.


### apidok command

#### apidok dist
Generate the documentation website
* `-i <doc>, --input=<doc>` Specify where you want the documentation to be generated, `doc` is the default folder
* `-o <dist>, --output=<dist>` Specify where you want the documentation to be generated, `dist` is the default folder
* `-v <version>, --version=<version>` Enable the documentation versioning, will generate the documentation in `<output>/<version>`
* `--extended-odels` Whether or not models can be extended, in this case `pet$default` will be the same as `pet`, and you can create for instance a `pet$detailled` which has a key `$extend: pet$demfault`. Value from `pet$default` will be copied inside `pet$detailled`
* `--enable-roles` Roles can be defined in the root of the resources.coffee: `roles: ['User', 'Manager', 'Admin']`, and a `roles` key can be added to api objects in the resources.coffee or to operation object in apis files. This key can be a string: `roles: 'User'`, or an array: `roles: ['Manager', 'Admin']`, if ommited, it means the call is accessible by everybody

#### apidok watch
Soon...

#### apidok clean
Soon...

#### apidok spec
Soon...

#### apidok help
Will display something similar to this section



License
-------

Copyright 2011-2012 Wordnik, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
