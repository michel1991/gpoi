/*
 * Copyright 2010 Stefano Gualdi
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package org.gualdi.grails.plugins.ckeditor.utils

import grails.util.Holders

/**
 * @author Stefano Gualdi <stefano.gualdi@gmail.com>
 */
class FileUtils {
    static isFileAllowed(filename, type) {
        def f = PathUtils.splitFilename(filename)
        return isAllowed(f.ext, type)
    }

    static isAllowed(ext, type) {
        def config = Holders.config.ckeditor.upload

        def resourceType = type.toLowerCase()
        if (resourceType == 'file') {
            resourceType = 'link'
        }
        def fileExt = ext.toLowerCase()

        def allowed = config."${resourceType}".allowed ?: []
        def denied = config."${resourceType}".denied ?: []

        return ((fileExt in allowed || allowed.empty) && !(fileExt in denied))
    }
}
