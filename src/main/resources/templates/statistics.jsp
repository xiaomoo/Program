

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">






    <script id="allmobilize" charset="utf-8" src="http://a.yunshipei.com/3cf4bf099041a90552a48c9d178339b6/allmobilize.min.js"></script>
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <meta name="format-detection" content="telephone=no,email=no,address=no">
    <link rel="alternate" media="handheld" href="#" />

    <link rel="shortcut icon" href="/images/favourite.ico">
    <link rel="stylesheet" type="text/css" href="/css/base.css">
    <link rel="stylesheet" type="text/css" href="/css/main.css">
    <!--高级查询样式-->
    <link rel="stylesheet" type="text/css" href="/css/high.css">
    <link rel="stylesheet" type="text/css" href="/js/nav/nav.css">
    <!--树控件样式-->
    <link rel="stylesheet" type="text/css" href="/js/ztree/zTreeStyle/zTreeStyle.css"/>
    <!--弹窗样式-->
    <link rel="stylesheet" type="text/css" href="/js/tips/css/tips.css" />
    <!--下拉样式-->
    <link rel="stylesheet" type="text/css" href="/js/dropList/css/dropList.css" />

    <script type="text/javascript" src="/modulejs/dynamic.jsp"></script>
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script type="text/javascript" src="/js/count/json2.js"></script>
    <script type="text/javascript" src="/js/nav/nav.js"></script>

    <!--引入树控件-->
    <script type="text/javascript" src="/js/ztree/js/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="/js/ztree/jquery.ytree.js"></script>

    <!--手风琴-->
    <script type="text/javascript" src="/js/jquery-Accordion.js"></script>
    <!--分栏拖拽-->
    <script type="text/javascript" src="/js/jquery-ySplitbar.js"></script>
    <!-- js通用方法  存放一些常使用的工具函数 -->
    <script type="text/javascript" src="/js/common.js"></script>
    <!-- 打印 -->
    <script type="text/javascript" src="/js/print/jquery.PrintArea.js"></script>

    <script type="text/javascript" src="/js/dropList/js/dropList.js"></script>
    <!-- 下载 -->
    <script type="text/javascript" src="/js/download.js"></script>
    <script type="text/JavaScript" src="/js/md5.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/easyquery.css">
    <title>国家数据</title>
    <link rel="stylesheet" type="text/css" href="/css/tablequery_td.css" />
    <script type="text/javascript" src="/js/loginBox.js"></script>
    <!--复制-->
    <script type="text/javascript" src="/js/tips/js/jquery.zclip.min.js"></script>

    <!--收藏-->
    <script type="text/javascript" src="/js/favorite/favoritePop.js"></script>
    <script type="text/javascript" src="/js/favorite/favoriteAdd.js"></script>
    <script type="text/javascript" src="/js/ztree/js/jquery.ztree.exedit-3.5.min.js"></script>

    <!-- 分享 -->
    <script type="text/javascript" src="/js/share/sharediv.js"></script>
    <script type="text/javascript" src="/js/main.js"></script>
    <script type="text/javascript" src="/js/tablequery.js"></script>

</head>

<body>
<!--打印div-->
<div style="display:none">
    <div id="printContent"></div>
</div>
<script type="text/javascript">
    var code = "AA1510";
    var rootTree = '[{"id":"AA","isParent":true,"name":"月度","pid":""},{"id":"AB","isParent":true,"name":"季度","pid":""},{"id":"AD","isParent":true,"name":"年度","pid":""}]';
    var baseurl = "";
    var ajaxUrl = "/tablequery.htm";
    var userid = "";
    var exceltable = [];
    var droplist = [];

    //收藏参数
    var actionStr="";
    var dbCode="";
    var wds="";
    var cparams="";
    var currentName="";
    var isDefault = true;

    var datatable = null;
    var datatitle = null;
    var droplists = null;
    var dataexps = null;
    var showleft=null;
    var showright=null;

    // 打印
    function printData() {
        setPrintFile();
    }

    function setPrintFile(){
        $("#printContent").empty();
        $("#printContent").append('<img class="left" src="/theme/pic/logo.png" />');

        var wds='<div width=400px;><div style="float:right;">';
        for ( var i = 0; i < droplist.length; i++) {
            var dt = droplist[i];
            if(dt.getItem().sort==1){
                wds = wds + dt.getWd().wdname + ":" + dt.getItem().name +"　　　";
            }
        }
        $("#printContent").append(wds+'</div></div><div class="clear"></div>');

        $("#printContent").append($("#tabledata").clone());

        if($(".expShow").is(":visible")){
            $("#printContent").append($(".expShow").clone());
        }
        $("#printContent").append('<div class="mt30 ml10">数据来源：国家统计局</div>');
        $("#printContent").printArea();
    }
    //下载
    function loadDownloadPop(){
        popTableQueryD();
    }
    //复制
    function copyTable(tableId){
        var thead = $("#"+tableId+" thead:eq(0)");
        var data="";
        // 取标题
        data = $("#datatitle").text() + "\t\n";;

        for (var i=0;i<droplist.length;i++){
            var dp = droplist[i];
            data+=dp.find(".wdName").text();
            data+=dp.getItem().name;
            data+='\t';
            //alert(dp.getItem().name);
            //alert(dp.find(".wdName").text());
        }
        data+="\n";
        //取tbody信息
        var tbody = $("#"+tableId+" tbody:eq(0)");
        for(var i=0;i<$(tbody).find("tr").length;i++){
            var tr = $(tbody).find("tr").eq(i);
            for(var j=0;j<$(tr).find("th").length;j++){
                data+=$(tr).find("th").eq(j).text();
                if(j<$(tr).find("th").length-1){
                    data+='\t';
                }
            }
            for(var j=0;j<$(tr).find("td").length;j++){
                data+=$(tr).find("td").eq(j).text();
                if(j<$(tr).find("td").length-1){
                    data+='\t';
                }
            }
            data+="\n";
        }

        data += '数据来源：国家统计局';
        return data;
    }

    $(function() {
        datatable = $(".tabledata");
        datatitle = $(".tableTitle");
        droplists = $("#divdroplist");
        dataexps = $(".expShow");
        showleft=$(".main-left");
        showright=$(".main-right");
        InitTree(tree);
        getwds(code);

        // 复制控制事件
        $("#copyA").zclip({
            path: "/js/tips/js/ZeroClipboard.swf",
            copy: function(){
                var userid = "";
                if (userid==""){
                    popLogin("");
                    return;
                }
                return copyTable("tabledata");
            },
            afterCopy:function(){
                alert("复制成功！");
            }
        });

        //分栏拖拽
        $("#main-container").ySplitbar({"number":1,"maxWidth":300,"minWidth":150,"barTop":"200","callback":splitbarFn});/*拖拽回调函数*/
        function splitbarFn(w){
            $(".lockTable_container,.table_container_main,.table_container_head").width(w);
            $(".table_container_main").find("table");
        }

    });

    //分享
    function share(){
        $.tips({
            title : "分享",
            content : sharediv,
            width : 250,
            height : 100,
            isCopy : false
        });

        //弹出分享后创建 分享脚本对象
        var shareScript = document.createElement("script");
        shareScript.type = "text/javascript";
        shareScript.src = "http://v3.jiathis.com/code/jia.js?uid=1406773923170934";
        document.getElementsByTagName("head")[0].appendChild(shareScript);
    }

    //收藏
    function saveFavorite(){
        openFvrtWin('/tablequery.htm?m=saveFavorite','',false);
    }
</script>

<!--页眉-->
<!-- 2015/1/12 13:17 -->









<div class="tc experience">为了获得更好的用户体验，请使用火狐、谷歌、360浏览器极速模式或IE9及以上版本的浏览器。<em class="close"></em></div>

<!--页眉-->
<div id="top">

    <div class="top-wrap">
        <div class="t-right mr5">
            <ul>

                <li><a href="/login.htm">登录</a></li>
                <li class="line"></li>
                <li><a href="/login.htm?m=toRegister">注册</a></li>

                <li class="line"></li>
                <li><a href="/english">English</a></li>
            </ul>
        </div>
    </div>
</div>
<div id="header">
    <h1>国家数据</h1>

    <!--nav start-->
    <div id="nav">
        <ul>
            <li><a href="/index.htm"><span class="first">首页</span></a></li>
            <li><a href='/easyquery.htm?cn=A01' >月度数据</a></li>

            <li><a href='/easyquery.htm?cn=B01' >季度数据</a></li>

            <li><a href='/easyquery.htm?cn=C01' >年度数据</a></li>

            <li><a href='http://www.stats.gov.cn/tjsj/pcsj/'  target='_blank'>普查数据</a></li>

            <li><a rel='menuE01'>地区数据</a></li>

            <li><a href='/staticreq.htm' >部门数据</a></li>

            <li><a rel='menuG01'>国际数据</a></li>

            <li><a href='/vchart.htm' >可视化产品</a></li>

            <li><a href='/publish.htm?sort=1' >出版物</a></li>

            <li><a href='/favorite.htm' >我的收藏</a></li>

            <li class='last'><a href='/ifnormal.htm?m=help&u=/files/html/help/help.html&h=690' >帮助</a></li>


        </ul>
    </div>
    <ul class='hidden' id='menuE01'><li><a  href='/easyquery.htm?cn=E0101' >分省月度数据</a>
    </li>
        <li><a  href='/easyquery.htm?cn=E0102' >分省季度数据</a>
        </li>
        <li><a  href='/easyquery.htm?cn=E0103' >分省年度数据</a>
        </li>
        <li><a  href='/easyquery.htm?cn=E0104' >主要城市月度价格</a>
        </li>
        <li><a  href='/easyquery.htm?cn=E0105' >主要城市年度数据</a>
        </li>
        <li><a  href='/easyquery.htm?cn=E0109' >港澳台月度数据</a>
        </li>
        <li><a  href='/easyquery.htm?cn=E0110' >港澳台年度数据</a>
        </li>
    </ul>
    <ul class='hidden' id='menuG01'><li><a  href='/easyquery.htm?cn=G0101' >主要国家(地区)月度数据</a>
    </li>
        <li><a  href='/easyquery.htm?cn=G0102' >三大经济体月度数据</a>
        </li>
        <li><a  href='/easyquery.htm?cn=G0103' >国际市场月度商品价格</a>
        </li>
        <li><a  href='/easyquery.htm?cn=G0104' >主要国家(地区)年度数据</a>
        </li>
        <li><a  href='/gwwz.htm' >国际组织网站</a>
        </li>
        <li><a  href='/gjwz.htm' >各国统计网站</a>
        </li>
    </ul>

    <!-- nav end-->

    <div class="top-search">
        <span class="search-img-title"><a href="/search.htm"><img style="" src="/images/shuku.jpg"/></a></span>
        <input type="text"  value="如：2012年 北京 GDP" maxlength="60" class="search-text"  id="keyword"/>
        <input type="button" value="搜索" class="search-btn" onclick="search()"/>
        <span class="img"></span>
    </div>

    <div class="keyword">
        <ul class="hot-index-container">

            <li><a href="/search.htm?s=GDP">GDP</a></li>

            <li><a href="/search.htm?s=CPI">CPI</a></li>

            <li><a href="/search.htm?s=总人口">总人口</a></li>

            <li><a href="/search.htm?s=社会消费品零售总额">社会消费品零售总额</a></li>

            <li><a href="/search.htm?s=粮食产量">粮食产量</a></li>

            <li><a href="/search.htm?s=PMI">PMI</a></li>

            <li><a href="/search.htm?s=PPI">PPI</a></li>

            <li><a href="/search.htm?s=城镇居民人均可支配收入">城镇居民人均可支配收入</a></li>

            <li><a href="/search.htm?s=农村居民家庭人均纯收入">农村居民家庭人均纯收入</a></li>

            <li><a href="/search.htm?s=城镇居民人均现金消费支出">城镇居民人均现金消费支出</a></li>

            <li><a href="/search.htm?s=人口">人口</a></li>

            <li><a href="/search.htm?s=gdp">gdp</a></li>

            <li><a href="/search.htm?s=房价">房价</a></li>

            <li><a href="/search.htm?s=房地产">房地产</a></li>

            <li><a href="/search.htm?s=国内生产总值">国内生产总值</a></li>

            <li><a href="/search.htm?s=工业增加值">工业增加值</a></li>

            <li><a href="/search.htm?s=cpi">cpi</a></li>

            <li><a href="/search.htm?s=生产总值">生产总值</a></li>

            <li><a href="/search.htm?s=??????">??????</a></li>

        </ul>
    </div>

</div>
<script type="text/javascript">
    autoExperience();
    function autoExperience(){
        var _l = Math.ceil( $("#header").offset().left );
        $(".experience").css({left:_l});
    }
    if($.cookie("experience") != "show"){
        $(".experience").show();
    }

    function search() {
        var str = $("#keyword").val();
        if ($.trim(str) != "" && str != "如：2012年 北京 GDP") {
            window.location = "/search.htm?s=" + str;
        }else{
            window.location = "/search.htm";
        }
    }
    $("#keyword").focus(function(){
        $(this).val() == "如：2012年 北京 GDP" && $(this).val("");
    }).blur(function(){
        $.trim($("#keyword").val()) == "" && $(this).val("如：2012年 北京 GDP");
    }).keydown(function(e){
        e.keyCode == 13 && search();
    });
</script>

<script type="text/javascript">
    $(function() {
        /*导航菜单*/
        menu("nav", "navbar");
        autoExperience();
        $(window).resize(function(){
            autoExperience();
        });
        $(".experience .close").click(function(){
            $(this).parent().hide();
            $.cookie("experience","show");
        });

        $(document).on('click', '.ierr', function(event){
            event.preventDefault();
            var curURL = encodeURIComponent(window.location.href);
            var resultURL = $(this).prop('href');
            window.open(resultURL + '&url=' + curURL);
        });
    });
</script>


<!-- main 开始 -->
<div id="main">
    <!--navbar 开始-->
    <div id="navbar">
        <!-- site 开始 -->
        <div id="site">
            <div class="site-left"></div>
            <div class="site-center">
                <ul class="ul-left pl15">
                    <li><a href="/index.htm">首页</a>
                    </li>
                    <li class="cur"><span class="left"></span><a href="javascript:void(0);" class="left">快速查询</a><span class="left last"></span>
                    </li>

                </ul>
                <ul class="ul-right right">
                    <li><a href="javascript:loginOper(loadDownloadPop)" title="下载" class="download mr15"></a>
                    </li>
                    <!-- <li><a id="copyA" class="copy mr20"></a></li> -->
                    <li><a href="javascript:loginOper(printData);" class="print mr15" title="打印"></a></li>
                    <li><a href="javascript:loginOper(share)" class="share mr10" title="分享"></a></li>
                </ul>
            </div>
            <div class="site-right"></div>
        </div>
        <!-- site 结束 -->

        <!-- subnav 开始 -->
        <div id="subnav">


            <div class="mattblackmenu right" id="rightmenu">
                <ul>
                    <li><a href="javascript:loginOper(saveFavorite);" id="sevaBtn"><img class="vm" src="/images/icon-2.png" width="18" height="18" /><span>添加收藏</span> </a>
                    </li>
                </ul>
            </div>
        </div>
        <!-- subnav 结束 -->
    </div>
    <!--navbar 结束-->

    <!-- main_content 开始-->
    <div id="m-wrap" class="mt10">
        <div id="main-container">
            <!-- main-left 开始"-->
            <div class="main-left left">
                <div class="ztree-container">
                    <ul id="tree" class="ztree"></ul>
                </div>

            </div>
            <!-- main-left 结束"-->

            <!-- main-right 开始-->
            <div class="main-right right">
                <div class="mr-header">
                    <div class="right" id="divdroplist"></div>
                </div>
                <!-- mr-content 开始 -->
                <div class="mr-content">
                    <div class="tableTitle"></div>
                    <div class="table-container" style="overflow-x:auto;min-height:325px;">
                        <table id="tabledata" class="tabledata" cellspacing="0" cellpadding="0" border="0" style="width:100%">

                        </table>
                    </div>
                    <!--注 开始-->
                    <div class="expShow">
                        <div class="zhu">注：</div>
                        <div class="explist"></div>
                    </div>
                    <!--注 结束-->
                </div>
                <!-- mr-content 结束 -->
            </div>
            <!-- main-right 结束-->
            <div class="clear"></div>
        </div>

    </div>
    <!-- main_content 结束-->
</div>
<!-- main 结束 -->

<!-- 引入页尾 -->






<!-- 在线留言开始 -->
<script type="text/javascript" src="/js/tips/js/tipsBox.js"></script>
<script src="/js/message/messagePop.js" type="text/javascript"></script>
<script type="text/javascript">
    var basePath="";
    //提交留言
    function addMsg(){
        var username = $.trim($("#usrname").val());
        var phone = $.trim($("#phone").val());
        var email = $.trim($("#email").val());
        var subject = $.trim($("#subject").val());
        var content = $.trim($("#detail").val());
        if(username == ""){
            alert("姓名不能为空！");
        } else if(username.length > 100){
            alert("姓名不能超过100个字符！");
        } else if(phone ==""){
            alert("电话号码不能为空！");
        } else if(phone!="" && !(/^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\d{8}$)/.test(phone))){
            alert("请输入正确的电话号码!\n如：0591-6487256,1581064****");
        } else if(email == ""){
            alert("电子邮件不能为空！");
        } else if(email.length > 100){
            alert("电子邮件不能超过100个字符！");
        } else if(!(/^([0-9a-zA-Z-_]){4,}@([0-9a-zA-Z])+((\.)[0-9a-zA-Z]+){1,2}$/.test(email))){
            alert("电子邮件格式不正确！邮箱@符号之前最少4个字符。");
        } else if(subject.length > 100){
            alert("留言主题不能超过100个字符！");
        } else if(content == ""){
            alert("留言内容不能为空！");
        } else if(content.length > 500){
            alert("留言内容不能超过500个字符！");
        } else{
            $.ajax({
                url :basePath+"/msg.htm",
                type : 'POST',
                data : {
                    m : "addMsg",
                    username : username,
                    phone : phone,
                    email : email,
                    subject : subject,
                    content : content
                },
                success : function(data){
                    if(data){
                        alert("留言成功！");
                        $(".closeBtn").trigger("click");
                    }else{
                        alert("操作失败！");
                    }
                }
            });
        }
    }

    //取消留言
    function cancelMsg(){
        $(".closeBtn").trigger("click");
    }

    //弹出留言板
    function showMessagePop(){
        //弹出收藏夹
        $.tips({
            title : '在线留言',
            content : messageDiv,
            width : 650,
            height : 400,
            drag : true,
            isCopy : false
        });

        //同步请求用户session数据
        $.ajaxSettings.async = false;
        $.getJSON(basePath+"/msg.htm", function(json){
            if(json!=null){
                $("#email").val(json.name);
                $("#phone").val(json.phone);
            }
        });
    };
</script>
<!-- 在线留言结束 -->


<!--footer-->
<div id="footer" class="clearfix">
    <div class="cpr">
        <ul>
            <li class="tittle">统计法规</li>
            <li><img src="images/footLine.jpg" border="0" /></li>
            <li><a
                    href="http://www.stats.gov.cn/zjtj/tjfg/tjfl/200906/t20090629_8791.html"
                    target="_blank">《统计法》</a></li>
            <li><a
                    href="http://www.stats.gov.cn/statsinfo/auto2072/201708/t20170803_1519739.html"
                    target="_blank">统计法实施条例</a></li>
            <li><a
                    href="http://www.stats.gov.cn/zjtj/tjfg/xzfg/201005/t20100528_36036.html"
                    target="_blank">人口普查条例</a></li>
            <li><a
                    href="http://www.stats.gov.cn/zjtj/tjfg/xzfg/201808/t20180824_1618906.html"
                    target="_blank">经济普查条例</a></li>
            <li><a
                    href="http://www.stats.gov.cn/zjtj/tjfg/gz/200904/t20090428_8810.html"
                    target="_blank">统计违法违纪行为处分规定</a></li>
            <li><a
                    href="http://www.stats.gov.cn/statsinfo/auto2072/201708/t20170803_1519666.html"
                    target="_blank">统计调查证管理办法</a></li>
            <li><a
                    href="http://www.stats.gov.cn/zjtj/tjfg/gz/200410/t20041018_8797.html"
                    target="_blank">涉外调查管理办法</a></li>
        </ul>
    </div>
    <div class="cpr">
        <ul>
            <li class="tittle">标准制度</li>
            <li><img src="images/footLine.jpg" border="0" /></li>
            <li><a href="http://www.stats.gov.cn/tjsj/tjbz/201301/t20130114_8675.html" target="_blank">国民经济行业分类</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/201701/t20170109_1451479.html"
                    target="_blank">国民经济核算统计报表制度</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/201701/t20170109_1451478.html"
                    target="_blank">基本单位统计报表制度</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/201701/t20170109_1451476.html"
                    target="_blank">农林牧渔业统计调查制度</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/201701/t20170109_1451473.html"
                    target="_blank">工业统计报表制度</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/201701/t20170109_1451375.html"
                    target="_blank">价格统计报表制度</a></li>
            <li><a
                    href="http://www.stats.gov.cn/tjsj/tjzd/gjtjzd/index_1.html"
                    target="_blank">更多制度&gt;&gt;</a></li>
        </ul>
    </div>
    <div class="cpr">
        <ul>
            <li class="tittle">统计数据生产过程</li>
            <li><img src="images/footLine.jpg" border="0" /></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201009/t20100920_57067.html" target="_blank">国内生产总值（GDP）</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201009/t20100920_57066.html" target="_blank">居民消费者价格指数（CPI）</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201109/t20110914_57080.html" target="_blank">生产者价格指数（PPI）</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201209/t20120919_57095.html" target="_blank">工业生产增长速度</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201209/t20120919_57096.html" target="_blank">固定资产投资</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201209/t20120919_57097.html" target="_blank">社会消费品零售总额</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201109/t20110914_57081.html" target="_blank">粮食产量</a></li>
            <li><a href="http://www.stats.gov.cn/tjzs/spdb/tjxcycb/201109/t20110915_57082.html" target="_blank">城乡居民收入与支出</a></li>
        </ul>
    </div>
    <div class="cpr02">
        <ul>
            <li class="tittle">在线电话</li>
            <li>咨询电话：010-68576320</li>
            <li class="tittle"></li>
            <li>周一至周五上午8：00-11:30,下午1:00-5:00</li>
        </ul>
    </div>
</div>
<div class="about">
    <table>
        <tbody>
        <tr>
            <td width="110" rowspan="4"><a href="http://bszs.conac.cn/sitename?method=show&id=0D0B77DBD5666A3EE053012819ACD529" target="_blank"><img src="/images/gov.png" alt="党政机关"></a></td>
            <td>版权所有：中华人民共和国国家统计局</td>
            <td width="160" rowspan="4"><a class="ierr" href="http://121.43.68.40/exposure/jiucuo.html?site_code=bm36000002" target="_blank"><img src="/images/err.png" alt="党政机关"></a></td>
        </tr>
        <tr>
            <td>地址：北京市西城区月坛南街57号（100826）</td>
        </tr>
        <tr>
            <td>网站标识码 bm36000005</td>
        </tr>
        <tr>
            <td>京ICP备05034670号</td>
        </tr>
        </tbody>
    </table>
</div>

</body>
</html>