# MT-DataAPI-Templates

# Usage (Japanese only)

## Target

 MT 6.0.x系で動作します。

 MT 6.1での動作は未確認です。MT 6.1では、DataAPI 2.0によりほぼ同等の機能が実装されて
いますので、そちらをご利用下さい。（APIエンドポイントおよびjsonの構造は、本プラグイン
のものと互換性はありません）

## Install

インストール方法

　pluginsディレクトリ以下を、MTのpluginsディレクトリに配置してください。

　サンプルを試したい場合、mt-static/pluginsディレクトリ以下を、MTのmt-static/pluginsディレクトリ以下に置いてください。

　サンプルの実行は、ブラウザから

http://xxx/mt-static/plugins/DataAPITemplates/index.html

にアクセスしてください。

　ログイン/ブログ選択/テンプレート一覧/テンプレート詳細/テンプレート更新が行えます。

## Endpoint

 以下のEndpointが利用出来ます。

 テンプレート一覧
 method : GET
 route : /sites/:site_id/donut/templates

 テンプレート詳細
 method : GET
 route : /sites/:site_id/donut/template/:template_id

 テンプレート作成
 method : POST
 route : /sites/:site_id/donut/templates

 テンプレート更新
 method : PUT
 route : /sites/:site_id/donut/template/:template_id


# License

Copyright (c) 2015 Kenichi Naito

MT-DataAPI-Templtes (except for the third party codes) is released under the MIT license.

For third party codes, read the following licenses.

## Third party codes and licenses.

Bootstrap 3.0 is a third-party library released under an MIT License.

See http://getbootstrap.com/getting-started/#license-faqs.

jQuery 1.10.2 is a third-party library released under an MIT License.

See https://jquery.org/license/.

mt-data-api.(min.)js is a third-party library released under an MIT License.

See mt-data-api.js comments which reads

 * Movable Type DataAPI SDK for JavaScript v1
 * https://github.com/movabletype/mt-data-api-sdk-js
 * Copyright (c) 2013 Six Apart, Ltd.
 * This program is distributed under the terms of the MIT license.
 *
 * Includes jQuery JavaScript Library in some parts.
 * http://jquery.com/
 * Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * Released under the MIT license
 * http://jquery.org/license
