# -*- coding: utf-8 -*-

import os
import re
import sys
import shutil
import requests
from requests import Response
from enum import Enum, unique

try:
    from authlib.jose import jwt
except ImportError:
    print("Trying to pip install authlib\n")
    #os.system('pip install authlib')

from datetime import datetime, timedelta


# 基础api
base_api = 'https://api.appstoreconnect.apple.com/v1/'

# api类型
@unique
class ApiType(Enum):

    # 构建版本
    connect_api_builds  = base_api + 'builds',

    # testflight
    connect_api_testflight  = base_api + 'betaAppReviewSubmissions',

    # betaGroup
    connect_api_betagroups  = base_api + 'betaGroups',

    # apps
    connect_api_apps  = base_api + 'apps',

    # appInfos
    connect_api_appInfos  = base_api + 'appInfos',

    # appstore版本
    connect_api_appStoreVersions  = base_api + 'appStoreVersions',

    # appstore版本信息
    connect_api_appStoreVersionLocalizations  = base_api + 'appStoreVersionLocalizations',

    # 提审
    connect_api_appStoreVersionSubmissions    = base_api + 'appStoreVersionSubmissions',

    # TODO: 其它

class Network:

    @classmethod
    def get(cls, url, params=None, header={}):
        res = requests.get(url, params=params, headers=header)
        json = res.json()
        return {'status': res.status_code, 'msg': '', 'data': json}

    @classmethod
    def post(cls, url, params=None, header={}):
        res = requests.post(url, json=params, headers=header)
        if res.status_code == 204 or res.status_code == 201:
            return {'status': 200, 'data': res.text}
        return {'status': res.status_code, 'data': res.text}

    @classmethod
    def patch(cls, url, params=None, header={}):
        res = requests.patch(url, json=params, headers=header)
        json = res.json()
        return {'status': res.status_code, 'msg': '', 'data': json}

    @classmethod
    def delete(cls, url, header={}):
        url = url
        res = requests.delete(url, headers=header)
        if res.status_code == 204:
            return {'status': 200, 'data': res.text}
        return {'status': res.status_code, 'data': res.text}

# 单例
class SingletonMeta(type):
    __instance = None

    def __call__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = type.__call__(cls, *args, **kwargs)
        return cls.__instance

# key_id 密钥ID
# issuer_id
# key_path 密钥文件路径
# expire_time 超时时间
class Token(object):
    def __init__(self, key_id, issuer_id, timeout, key_path=None):
        self.__keyId = key_id
        self.__issuerId = issuer_id
        self.__timeout = timeout
        self.__expire_time = 0
        self.__token = None
        self.__set_key_path(key_path)

    def __set_key_path(self, value):
        self.__key_path = None
        if value and os.path.exists(value):
            self.__key_path = value
        else:
            home = os.environ['HOME']
            for path in os.listdir(home):
                if 'private_keys' in path:
                    private_keys_path = os.path.join(
                        home, path, 'AuthKey_'+self.__keyId+'.p8')
                    if os.path.exists(private_keys_path):
                        self.__key_path = private_keys_path
                        print(self.__key_path)
                        break
        if not self.__key_path:
            raise Exception('private_keys not exist')

    def __private_key(self):
        with open(self.__key_path, 'r') as fp:
            try:
                return fp.read()
            except Exception as excep:
                print(excep)

    @property
    def __is_expire(self):
        if datetime.now().timestamp() < self.__expire_time:
            return False
        return True

    @property
    def token(self) -> str:
        if not self.__token or self.__is_expire:
            self.__expire_time = int(
                (datetime.now()+timedelta(minutes=self.__timeout)).timestamp())
            self.__token = Token.encode(
                self.__keyId, self.__issuerId, self.__private_key(), self.__expire_time)
        return str(self.__token, encoding='utf-8')

    @classmethod
    def encode(cls, key_id, issuer_id, private_key, expire_time):
        payload = {'iss': issuer_id,
                   'exp': expire_time,
                   'aud': 'appstoreconnect-v1'}
        result = jwt.encode(header={
                            'kid': key_id, 'typ': 'JWT', "alg": "ES256"}, payload=payload, key=private_key)
        return result

class Api(metaclass=SingletonMeta):
    def __init__(self):
        self.__token_object = None

    @property
    def tokenConfig(self):
        return self.__token_object

    @tokenConfig.setter
    def tokenConfig(self, token: Token):
        self.__token_object = token

    @property
    def __header(self):
        if not self.__token_object:
            raise Exception('token object not exist')
        return {"Authorization": 'Bearer '+self.__token_object.token}

    def list_builds(self, url: str, limit, sort):
        params = {'limit': limit, 'sort': sort}
        print(url)
        return Network.get(url, params=params, header=self.__header)

    def modify_build(self, url: str, id):
        url = url+'/'+id
        params = {'data': {'attributes': {'expired': False, 'usesNonExemptEncryption':False},
                           'id': id, 'type': "builds"}}
        print(url)
        return Network.patch(url, params=params, header=self.__header)
    
    def add_build_to_betaGroup(self, url: str, id, betaGroupId):
        url = url+'/'+id + '/relationships/betaGroups'
        params = {'data': [{'id': betaGroupId, 'type': "betaGroups"}]}
        print(url)
        return Network.post(url, params=params, header=self.__header)

    def submit_beta(self, url: str, id):
        params = {'data': {'relationships': {'build':{'data':{'id':id, 'type':'builds'}}}, 'type': "betaAppReviewSubmissions"}}
        print(url)
        return Network.post(url, params=params, header=self.__header)

    def list_beta_groups(self, url: str, limit, sort):
        params = {'limit': limit, 'sort': sort}        
        print(url)
        return Network.get(url, params=params, header=self.__header)

    def list_apps(self, url: str, limit, sort):
        params = {'limit': limit, 'sort': sort}        
        print(url)
        return Network.get(url, params=params, header=self.__header)
    
    def read_app_info(self, url: str, id):
        url = url + '/' +  id  
        print(url)
        return Network.get(url, header=self.__header)

    def list_territories(self, url: str, id):
        url = url + '/' +  id  + '/availableTerritories'
        print(url)
        return Network.get(url, header=self.__header)

    def list_appInfos(self, url: str, id):    
        url = url + '/' +  id  + '/appInfos'  
        print(url)
        return Network.get(url, header=self.__header)

    def list_appInfo_localizations(self, url: str, id):    
        url = url + '/' +  id  + '/appInfoLocalizations'  
        print(url)
        return Network.get(url, header=self.__header)

    def get_appStoreVersions(self, url: str, id):
        url = url + '/' +  id  + '/appStoreVersions'  
        print(url)
        return Network.get(url, header=self.__header)
    
    def create_an_appstore_version(self, url, version, appid, buildid):
        # params = {'data':{ 'attributes':{'platform':'IOS', 'versionString':version},
        #                    'relationships':{'app':{'data':{'id':appid, 'type':'apps'}}, 'build':{'data':{'id':buildid, 'type':'builds'}}},
        #                    'type': "appStoreVersions"}}   
        params = {'data':{ 'attributes':{'platform':'IOS', 'versionString':version},
                           'relationships':{'app':{'data':{'id':appid, 'type':'apps'}}},
                           'type': "appStoreVersions"}}  
                           
        print(url)
        return Network.post(url, params=params, header=self.__header)

    def modify_an_appstore_version(self, url, id, buildid):
        params = {'data':{
                           'id': id, 
                           'relationships':{'build':{'data':{'id':buildid, 'type':'builds'}}},
                           'type': "appStoreVersions"}}  
        url = url + '/' +  id  
        print(url)
        return Network.patch(url, params=params, header=self.__header)

    def delete_an_appstore_version(self, url, id):
        url = url + '/' +  id
        return Network.delete(url, header=self.__header)

    def get_appStoreVersionLocalizations(self, url: str, id):  
        url = url + '/' +  id  + '/appStoreVersionLocalizations'
        print(url)
        return Network.get(url, header=self.__header)

    def read_appStoreVersionLocalizations(self, url: str, id):  
        url = url + '/' +  id  
        print(url)
        return Network.get(url, params=params, header=self.__header)

    def modify_appStoreVersionLocalizations(self, url: str, id, promotionalText, whatsNew):  
        # params = {'data':{'attributes': {'description': '', 'keywords':'', 'marketingUrl':'', 'promotionalText':'', 'supportUrl':'', 'whatsNew':''},
        #                    'id': id, 'type': "appStoreVersionLocalizations"}}
        params = {'data':{'attributes': {'promotionalText':promotionalText, 'whatsNew':whatsNew},
                           'id': id, 'type': "appStoreVersionLocalizations"}}  
        url = url + '/' +  id  
        print(url)
        return Network.patch(url, params=params, header=self.__header)

    def submit_appStoreVersionSubmissions(self, url: str, id):  
        params = {'data':{'relationships': {'appStoreVersion':{'data':{'id':id, 'type':'appStoreVersions'}}},
                           'type': "appStoreVersionSubmissions"}}   
        print(url)
        return Network.post(url, params=params, header=self.__header)
    
    def read_appStoreVersionSubmissions(self, url: str, id):  
        url = url + '/' +  id + '/appStoreVersionSubmission' 
        print(url)
        return Network.get(url, header=self.__header)

    def delete_appStoreVersionSubmissions(self, url: str, id):  
        url = url + '/' +  id  
        print(url)
        return Network.delete(url, header=self.__header)


class Build:

    @classmethod
    def builds(cls, limit, sort):
        result = Api().list_builds(
            ApiType.connect_api_builds.value[0], limit, sort)

        print(result)
        return result

    @classmethod
    def get_lastest_build_id(cls):
        """获取最新的build id
        """
        buildId = None

        # 检查及修改版本信息
        result = Build.builds(limit=100, sort='-preReleaseVersion')
        if not user_work_result('获取所有构建版本', result):
            return

        builds = result['data']['data']
        if not builds:
            print('\t无构建版本，请先上传构建版本！！\n')
            return

        list_builds = []
        for build in builds:
            list_builds.append({'id':build['id'], 'version':int(build['attributes']['version'])})
        
        # 排序
        list_builds.sort(key=lambda x: x['version'], reverse=True)
        
        # 检查最新版本及版本号
        last_build = list_builds[0]
        print('最新版本={}'.format(last_build))
        buildId = last_build['id']
        return buildId
    
    @classmethod
    def modify_build(cls, id):
        result = Api().modify_build(
            ApiType.connect_api_builds.value[0], id)
        print(result)
        return result
    
    @classmethod
    def add_build_to_betaGroup(cls, id, betaGroupId):
        result = Api().add_build_to_betaGroup(
            ApiType.connect_api_builds.value[0], id, betaGroupId)
        print(result)
        return result

class TestFlight:

    @classmethod
    def submit_beta(cls, id):
        result = Api().submit_beta(
            ApiType.connect_api_testflight.value[0], id)

        print(result)
        return result

    @classmethod
    def list_beta_groups(cls, limit, sort):
        result = Api().list_beta_groups(
            ApiType.connect_api_betagroups.value[0], limit, sort)
        print(result)
        return result

class AppStore:

    @classmethod
    def list_apps(cls, limit, sort):
        result = Api().list_apps(
            ApiType.connect_api_apps.value[0], limit, sort)
        print(result)
        return result
    
    @classmethod
    def read_app_info(cls, id):
        result = Api().read_app_info(
            ApiType.connect_api_apps.value[0], id)
        print(result)
        return result

    @classmethod
    def list_territories(cls, id):
        result = Api().list_territories(
            ApiType.connect_api_apps.value[0], id)
        print(result)
        return result
        
    @classmethod
    def list_appinfos(cls, id):
        result = Api().list_appInfos(
            ApiType.connect_api_apps.value[0], id)
        print(result)
        return result

    @classmethod
    def list_appInfo_localizations(cls, id):
        result = Api().list_appInfo_localizations(
            ApiType.connect_api_appInfos.value[0], id)
        print(result)
        return result

    @classmethod
    def get_appStoreVersions(cls, id):
        result = Api().get_appStoreVersions(
            ApiType.connect_api_apps.value[0], id)
        print(result)
        return result
    
    @classmethod
    def create_an_appstore_version(cls, version, appid):
        result = Api().create_an_appstore_version(
            ApiType.connect_api_appStoreVersions.value[0], version, appid, '')
        print(result)
        return result

    @classmethod
    def modify_an_appstore_version(cls, id, buildid):
        result = Api().modify_an_appstore_version(
            ApiType.connect_api_appStoreVersions.value[0], id, buildid)
        print(result)
        return result

    @classmethod
    def delete_an_appstore_version(self, id):
        result = Api().delete_an_appstore_version(
            ApiType.connect_api_appStoreVersions.value[0], id)
        print(result)
        return result

    @classmethod
    def get_appStoreVersionLocalizations(cls, id):
        result = Api().get_appStoreVersionLocalizations(
            ApiType.connect_api_appStoreVersions.value[0], id)
        print(result)
        return result

    @classmethod
    def read_appStoreVersionLocalizations(cls, id):
        result = Api().read_appStoreVersionLocalizations(
            ApiType.connect_api_appStoreVersionLocalizations.value[0], id)
        print(result)
        return result

    @classmethod
    def modify_appStoreVersionLocalizations(cls, id, promotionalText, whatsNew):
        result = Api().modify_appStoreVersionLocalizations(
            ApiType.connect_api_appStoreVersionLocalizations.value[0], id, promotionalText, whatsNew)
        print(result)
        return result
    
    @classmethod
    def submit_appStoreVersionSubmissions(self, id):  
        result = Api().submit_appStoreVersionSubmissions(
            ApiType.connect_api_appStoreVersionSubmissions.value[0], id)
        print(result)
        return result

    @classmethod
    def read_appStoreVersionSubmissions(self, id):  
        result = Api().read_appStoreVersionSubmissions(
            ApiType.connect_api_appStoreVersions.value[0], id)
        print(result)
        return result
    
    @classmethod
    def delete_appStoreVersionSubmissions(self, id):  
        result = Api().delete_appStoreVersionSubmissions(
            ApiType.connect_api_appStoreVersionSubmissions.value[0], id)
        print(result)
        return result

# 操作结果
def user_work_result(content, result):
    if result is not None:
        if result['status'] == 200:
            print('\n {} 操作成功🎉🎉🎉 \n'.format(content))
            return True
        else:
            print('\n {} 操作失败😔😔😔 \n error = {}'.format(content, result))
    return False

# 读取文件内容
def read_text_content(fileName):
    work_path = '/Users/huangzugang/Desktop/workspace/leyou/vpn_client_ios/archive/version'
    file_path = os.path.join(work_path, fileName)
    with open(file_path,'r',encoding='utf-8') as f:
        content = f.read()
    f.close()
    return content

class AppstoreTool:

    """
    应用商店助手，基于appstore connect api
    @see https://developer.apple.com/documentation/appstoreconnectapi
    """

    def __init__(self, api_key, issuer_id, private_path=None, timeout=15):
        token_object = Token(
            api_key, issuer_id, key_path=private_path, timeout=timeout)
        Api().tokenConfig = token_object

    def submit_to_testflight(self):
        
        buildId = None

        # 检查及修改版本信息
        result = Build.builds(limit=100, sort='-preReleaseVersion')
        if not user_work_result('获取所有构建版本', result):
            return

        builds = result['data']['data']
        if not builds:
            print('\t无构建版本，请先上传构建版本！！\n')
            return

        list_builds = []
        for build in builds:
            list_builds.append({'id':build['id'], 'version':int(build['attributes']['version'])})
        
        # 排序
        list_builds.sort(key=lambda x: x['version'], reverse=True)
        
        # 检查最新版本及版本号
        last_build = list_builds[0]
        print('最新版本={}'.format(last_build))
        buildId = last_build['id']
        
        # 修改版本信息
        result = Build.modify_build(buildId)
        user_work_result('修改构建版本信息', result)

        # 提交审核
        result = TestFlight.submit_beta(buildId)
        user_work_result('提交beta版审核', result)
        
        # 获取betaGroup及把构建版本添加至测试
        result = TestFlight.list_beta_groups(limit=100, sort='-createdDate')
        if not user_work_result('获取外部的测试群组', result):
            return

        betaGroup = result['data']['data']
        if not betaGroup:
            print('\t无外部的测试群组，请先创建\n')
            # TODO: 创建群组
            return
        
        groupId = None
        pulbicLink = None
        for group in betaGroup:
            if group['type'] == 'betaGroups' and group['attributes']['publicLinkEnabled']:
                groupId    = group['id']
                pulbicLink = group['attributes']['publicLink']
                break
        
        if not groupId:
            print('\t没有找到外部测试组!\n')
            return
        
        result = Build.add_build_to_betaGroup(buildId, groupId)
        user_work_result('构建版本添加至测试组或提交测试', result)

        # 共享链接
        print('共享链接={}'.format(pulbicLink))
    
    def get_appstoreversions_info(self):
        """获取appstoreversion id
        """
        
        # 查询appStoreVersions
        appStoreVersions = AppStore.get_appStoreVersions('1545137268')
        data = appStoreVersions['data']['data']
        if not data:
            print('数据为空')
            return None
        
        version = None
        id = None
        for one_data in data:
            versionString = one_data['attributes']['versionString']
  
            if not version or versionString > version:
                version = versionString
                id =  one_data['id']
        
        return id, version

    def get_inreview_appstoreversions_info(self):
        """获取正在等待审核的版本信息
        """
        
        # 查询appStoreVersions
        appStoreVersions = AppStore.get_appStoreVersions('1545137268')
        data = appStoreVersions['data']['data']
        if not data:
            print('数据为空')
            return None
        
        version = None
        id = None
        for one_data in data:
            versionString = one_data['attributes']['versionString']
  
            if one_data['attributes']['appStoreState'] == 'WAITING_FOR_REVIEW':
                version = versionString
                id =  one_data['id']
        
        return id, version
    
    def submit_to_appstore(self):
        # 选择
        while True:
            index = user_get_selector(
                ['=========================',
                '1. 查询apps',
                '2. 查询指定appstore version',
                '3. 查询指定appstore version本地化语言',
                '4. 创建版本',
                '5. 提审',
                '6. 返回上一级',
                '========================='
                ])
            if index == 1:
                # 查询app信息
                AppStore.list_apps(limit=10, sort='bundleId')
            elif index == 2:
                id = input("请输入appid:").strip()
                AppStore.get_appStoreVersions(id)
            elif index == 3:
                id = input("请输入appStoreVersionsid:").strip()
                AppStore.get_appStoreVersionLocalizations(id)
            elif index == 4:
                version = input("请输入version:").strip()
                AppStore.create_an_appstore_version(version, '1545137268')
            elif index == 5:

                # 查找最新的buildid
                build_id = Build.get_lastest_build_id()

                # appstore version id
                appstore_version_id, version = self.get_appstoreversions_info()
                
                # 修改版本信息
                result = Build.modify_build(build_id)
                user_work_result('修改构建版本信息', result)

                # 更新appstore版本
                # build更新
                result = AppStore.modify_an_appstore_version(appstore_version_id, build_id)
                user_work_result('更新appstore版本 修改build', result)

                # 指定版本的本地化语言
                appStoreVersionLocalizations = AppStore.get_appStoreVersionLocalizations(appstore_version_id)
                user_work_result('获取指定版本的本地化语言信息', appStoreVersionLocalizations)

                data = appStoreVersionLocalizations['data']['data']
                if not data:
                    print('数据为空')
                    return None

                # 更新上传信息与宣传语
                promotionalText = read_text_content('promotionalText.txt')
                whatsNew = read_text_content('whatsNew.txt')

                for one_data in data:
                    result = AppStore.modify_appStoreVersionLocalizations(one_data['id'], promotionalText, whatsNew)
                    user_work_result('更新本地化语言信息[{}]'.format(one_data['attributes']['locale']), appStoreVersionLocalizations)
                
                # 提审
                result = AppStore.submit_appStoreVersionSubmissions(appstore_version_id)
                user_work_result('版本{} 提交审核'.format(version), appStoreVersionLocalizations)

            else:
                break

    def delete_in_review(self):
        # 删除正在审核的版本
        # appstore version id
        appstore_version_id, version = self.get_inreview_appstoreversions_info()

        # 没有找到
        if not appstore_version_id or not version:
            print('没有正在等待审核的版本！')
            return

        # 查询提审信息
        result = AppStore.read_appStoreVersionSubmissions(appstore_version_id)
        user_work_result('\n查询版本{}的审核信息'.format(version), result)

        # 删除
        if result:
            data = result['data']['data']
            id = data['id']

            result = AppStore.delete_appStoreVersionSubmissions(id)
            user_work_result('\n删除正在审核版本{}'.format(version), result)

class Transporter:
    """[Transporter]
    """

    def __init__(self, target_folder, account, psw_upload):
        self.transporter_path = "/usr/local/itms/bin/iTMSTransporter"

        # 当前操作目录
        self.target_folder = target_folder
        if not os.path.exists(self.target_folder):
            os.mkdir(self.target_folder)
        
        self.account = account
        self.psw_upload = psw_upload

        # 日志文件
        self.log_file = os.path.join(self.target_folder, "transporter_log.txt")
        if os.path.exists(self.log_file):
            os.remove(self.log_file)
        
        # 是否已完成
        self.successed = False
    
    def _log(self, value):
        """
        输出日志信息
        """
        if value is None:
            return

        # value = "【{}】{}".format(self.apple_id or "", value)
        # print(value)

        file_path = os.path.join(self.target_folder, "日志.txt")

        with open(file_path, "a") as f:
            f.write(value + "\r\n")
    
    def _find_a_file(self, extension):
        """
        搜索一个文件，可用于默认值获取
        @param extension            文件后缀
        """
        if extension is None: return None
        if not extension.startswith("."):
            extension = "." + extension

        files = os.listdir(self.target_folder)
        for the_file in files:
            filename, file_extension = os.path.splitext(the_file)
            # print(the_file, filename, file_extension)
            if file_extension == extension:
                return os.path.join(self.target_folder, the_file)
        
        return None


    def upload(self):
        """[上传ipa]
        """
        ipa_file = self._find_a_file(".ipa")
        plist_file = self._find_a_file(".plist")
        if ipa_file is not None and plist_file is not None:
            # 开始上传ipa
            self._log("开始上传ipa...")

            cmd_v = '{} -m upload -u {} -p {} -assetFile {} -assetDescription {} -o {} -v eXtreme -WONoPause true'.format(self.transporter_path, self.account, self.psw_upload, ipa_file, plist_file, os.path.join(self.target_folder, self.log_file))

            # 写入文件
            # bat_file_ = open(os.path.join(self.target_folder, "uploadipa.bat"), "w+")
            # bat_file_.write(cmd_v)
            # bat_file_.close()

            os.system(cmd_v)
        
        self._log("完成上传")
        self.successed = True


# 自动化打包
class ArchiveIPA:
    """
    Xcode 自动化打包工具
    @see https://developer.apple.com/library/archive/technotes/tn2339/_index.html#//apple_ref/doc/uid/DTS40014588-CH1-HOW_DO_I_BUILD_MY_PROJECTS_FROM_THE_COMMAND_LINE_
    """

    def start(self):

        work_path = "/Users/huangzugang/Desktop/workspace/leyou/vpn_superv/archive"
        proj_path = os.path.join(work_path, '../', 'International.xcworkspace')
        schemeName = 'International'

        # clean build
        self._clean_build(work_path)

        # clean
        self._clean(proj_path, schemeName)

        # 打包
        self._archive(proj_path, schemeName, work_path)

        # # ipa
        self._ipa(work_path, schemeName)
            # # 上传ipa至appstore
            # transporter = Transporter(os.path.join(work_path, 'build'), "tatesmbewce@hotmail.com", "epxz-fsvf-yaik-rjur")
            # transporter.upload()
        # # ipa
        # if self._ipa(work_path, schemeName):
        #     # 上传ipa至appstore
        #     transporter = Transporter(os.path.join(work_path, 'build'), "tatesmbewce@hotmail.com", "epxz-fsvf-yaik-rjur")
        #     transporter.upload()
        

    def _clean_build(self, work_path):
        build_path = os.path.join(work_path, "build")
        if os.path.exists(build_path):
            shutil.rmtree(build_path)           

    def _clean(self, proj_path, schemeName):
        proj = 'project' if proj_path.endswith(".xcodeproj") else 'workspace'
        cmd = "xcodebuild clean -{} {} -scheme {} -configuration Release".format(
            proj, proj_path, schemeName)
        os.system(cmd)

    def _archive(self, proj_path, schemeName, work_path):
        """[打包]
        """
        # archive
        proj = 'project' if proj_path.endswith(".xcodeproj") else 'workspace'
        cmd = "xcodebuild archive -{} {} -scheme {} -configuration Release -archivePath {}/build/{}.xcarchive".format(
            proj, proj_path, schemeName, work_path, schemeName)
        os.system(cmd)

    def _ipa(self, work_path, schemeName):
        """[ipa]
        """

        # copy file
        exportPlistPath = os.path.join(work_path, 'ExportOptions.plist')
        srcPlistPath    = os.path.join(self._resource_path('ExportOptions'), 'ExportOptions.plist')
        self._copy_file_to(srcPlistPath, exportPlistPath)

        # 导出ipa
        cmd = "xcodebuild -exportArchive -archivePath {}/build/{}.xcarchive -configuration Release -exportPath {}/build -exportOptionsPlist {}".format(
            work_path, schemeName, work_path, exportPlistPath)
        os.system(cmd)

        # 导出plist
        cmd = 'xcrun swinfo -f {} -o {} -prettyprint true --plistFormat binary'
        ipa_file = os.path.join(work_path, "build", "{}.ipa".format(schemeName))
        
        # ipa不存在
        if not os.path.exists(ipa_file):
            print("导出失败，ipa包不存在".center(25, '😔'))
            return False
        
        # 导出
        plist_path = ipa_file.replace(".ipa", ".plist")
        cmd = cmd.format(ipa_file, plist_path)
        os.system(cmd)

        print("导出成功".center(25, '🎉'))
        return True

    # 获取资源路径
    def _resource_path(self, relative_path):
        if getattr(sys, 'frozen', False):
            base_path = sys._MEIPASS
        else:
            base_path = os.path.abspath(".")
        return os.path.join(base_path, relative_path)
    
    def _copy_file_to(self, src_file, dst_file):
       
        if os.path.exists(dst_file):
            # in case of the src and dst are the same file
            if os.path.samefile(src_file, dst_file):
                return
            os.remove(dst_file)
        shutil.copy(src_file, dst_file)
        print("copy file>>", src_file)

# 用户选择
def user_get_selector(arr:list):
    for a in arr:
        print(a)
    content = input("请选择:").strip()
    if content.isdigit() is False:
        return -1
    else:
        return int(content)

def doArchive():
    archive = ArchiveIPA()
    archive.start()

# 开始自动化打包
if __name__ == "__main__":

    # api_key
    api_key = "6JNFBJ7K9K"  # input("请输入api_key: \n").strip()

    # issuer_id
    # input("请输入issuer_id: \n").strip()
    issuer_id = "23464f82-f1b9-4a0e-a274-40fb44e178af"

    # private_path
    # input("请输入private_path: \n").strip()
    private_path = "/Users/huangzugang/Desktop/workspace/leyou/vpn_client_ios/archive/AuthKey_6JNFBJ7K9K.p8"

    # teamId
    team_id = "3KBDC4X4N5"  # input("请输入teamId: \n").strip()

    # tool
    tool = AppstoreTool(api_key, issuer_id, private_path)

    # 选择
    while True:
        index = user_get_selector(
            ['=========================',
             '1. 打包ipa',
             '2. 发布TestFlight',
             '3. 发布AppStore',
             '4. 撤销正在审核的AppStore版本',
             '========================='
             ])
        if index == 1:
            doArchive()
        elif index == 2:
            tool.submit_to_testflight()
        elif index == 3:
            tool.submit_to_appstore()
        elif index == 4:
            tool.delete_in_review()
        else:
            print('\n输入错误，请重新选择!!😅😅😅\n')
    

