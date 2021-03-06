// Copyright 2017, Google, Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
((() => {

    const module = angular.module('qiqAuth');

    module.controller('AuthController', AuthController);

    AuthController.$inject = ['$location', 'authFactory']

    function AuthController($location, authFactory) {
        const ac = this;
        ac.register = register;
        init();

        function init() {

        }

        function register() {
            authFactory.register(ac.email, ac.password).then(() => {
                $location.path('/quiz/gcp');
            });
        }
    }
}))();
