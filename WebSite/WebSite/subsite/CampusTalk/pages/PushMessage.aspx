<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PushMessage.aspx.cs" Inherits="WebSite.subsite.CampusTalk.pages.PushMessage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CampusTalk后台推送系统</title>
    <link href="../../../css/bootstrap.css" rel="stylesheet" />
    <link href="../../../css/style.css" rel="stylesheet" />
    <link href="../../../css/txt/font-awesome.min.css" rel="stylesheet" />
    <script src="../js/classie.js"></script>
    <link href="../../../css/txt/component.css" rel="stylesheet" />
    <link href="../../../css/txt/demo.css" rel="stylesheet" />
    <link href="../../../css/txt/font-awesome.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <div id="top-image">
                <div id="content">
                    <div class="jumbotron" style="padding: 0px">
                        <div>
                            <h2 style="margin: 30px; margin-top: 100px">CampusTalk 推送</h2>
                            <div>
                                <span class="input input--juro" >
                                    <asp:TextBox runat="server" class="form-control" Width="370px" TextMode="SingleLine" MaxLength="10" ID="tvTitle" />

                                </span>
                                <br />
                                <span class="input input--juro" style="height: 200px">
                                    <asp:TextBox Rows="15" MaxLength="150" runat="server" class="form-control" TextMode="MultiLine" ID="tvContent" />

                                </span>
                                <span class="input-group-btn">
                                    <asp:Button ID="btn_push" Text="推送" OnClick="btn_push_Click" runat="server" class="btn btn-default" Style="border-top-left-radius: 6px; border-bottom-left-radius: 6px; max-width: 300px; width: calc(50% - 2em); margin: 1em" type="button"></asp:Button>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="../../../js/jquery.min.js"></script>
    <script src="../js/ios-parallax.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#top-image').iosParallax({
                movementFactor: 50
            });
        });
        (function () {
            if (!String.prototype.trim) {
                (function () {
                    // Make sure we trim BOM and NBSP
                    var rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
                    String.prototype.trim = function () {
                        return this.replace(rtrim, '');
                    };
                })();
            }

            [].slice.call(document.querySelectorAll('input.input__field')).forEach(function (inputEl) {
                // in case the input is already filled..
                if (inputEl.value.trim() !== '') {
                    classie.add(inputEl.parentNode, 'input--filled');
                }

                // events:
                inputEl.addEventListener('focus', onInputFocus);
                inputEl.addEventListener('blur', onInputBlur);
            });
            [].slice.call(document.querySelectorAll('textarea.input__field')).forEach(function (inputEl) {
                // in case the input is already filled..
                if (inputEl.value.trim() !== '') {
                    classie.add(inputEl.parentNode, 'input--filled');
                }

                // events:
                inputEl.addEventListener('focus', onInputFocus);
                inputEl.addEventListener('blur', onInputBlur);
            });
            function onInputFocus(ev) {
                classie.add(ev.target.parentNode, 'input--filled');
            }

            function onInputBlur(ev) {
                if (ev.target.value.trim() === '') {
                    classie.remove(ev.target.parentNode, 'input--filled');
                }
            }
        })();
    </script>

</body>

</html>
