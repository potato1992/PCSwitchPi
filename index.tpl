<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Remote PC power management</title>
    
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>

    <script>
        var base_uri="";
        //get relative path
        function get_url_relative_path(){
    　　　　var url = document.location.toString();
    　　　　var arrUrl = url.split("//");
    　　　　var start = arrUrl[1].indexOf("/");
    　　　　var relUrl = arrUrl[1].substring(start);//stop省略，截取从start开始到结尾的所有字符
    　　　　if(relUrl.indexOf("?") != -1){
    　　　　　　relUrl = relUrl.split("?")[0];
    　　　　}
    　　　　return relUrl;
    　　}

        window.onload=function(){
            console.log("初始化页面触发js函数:我是页面加载完打印的bai");
            funName()
        }
        var funName = function(){
            console.log("初始化页面触发js函数:我是页面加载完,调用的");
            base_uri=get_url_relative_path();
        }
    </script>

    <script>        
        //maintenance timer (1s interval)
        var timer_maintenance=self.setInterval("maintenance_clock()",1000);
        function maintenance_clock(){
            var d=new Date();
            var str_t=d.toLocaleTimeString();
            //get LED status
            var v=$.post(base_uri+"/get_status","LED",function(result,status){
                    //parse result
                    //alert(result);
                    x = document.getElementById("status_led");
                    x.innerHTML = "LED: "+result;//change content
                });


            console.log("Last timer:"+str_t);
        }

        $(function(){            
            $("button").click(function(){
                cmd="{cmd:"+this.id+"}"
                //alert(cmd)
                x = document.getElementById("status_text");
                x.innerHTML = "Working...";//change content
                x.style.color="#000000"; //change style

                document.getElementById("spin_main").style.visibility="visible";

                var data=this.id+"+"+document.getElementById("input_pass").value;
                var v=$.post(base_uri+"/cmd",data,function(result,status){
                    //parse result
                    //alert(result);
                    x = document.getElementById("status_text");
                    x.innerHTML = result;//change content                    
                    x.style.color="#ff0000"; //change style
                    document.getElementById("spin_main").style.visibility="hidden";
                });                
            });

        });

    </script>


</head>
<body>
<div id="container" class="container">

    <h2>Remote PC power management</h2>

    <form method="POST" action="" name="forms">  
        <span id=box><input type="password" id="input_pass" name="password" placeholder="Password" ></span>  
        <span id=click><a href="javascript:showps()">Show password</a></span>
    </form> 

    <br/>

    <div>
        <button id='Power' class="btn btn-outline-primary" 
            data-toggle="tooltip" data-placement="top" title="Quich press the power button">Power</button>
        <button id='Reset' class="btn btn-outline-primary"
            data-toggle="tooltip" data-placement="top" title="Quich press the reset button">Reset</button>
        <button id='Force power down' class="btn btn-outline-primary"
            data-toggle="tooltip" data-placement="top" title="Hold the power button for 8 seconds">Force power down</button>
        <div class="spinner-border text-primary" role="status" style="visibility:hidden;" id="spin_main">
            <span class="sr-only">Loading...</span>
        </div>
    </div>

    <br/>

    <div class="alert alert-dark" role="alert" id="status_led">No checked</div>
    <div class="alert alert-dark" role="alert" id="status_text">Ready</div>


</div>

<script language="JavaScript">   
            function showps(){   
                if (this.forms.password.type="password") {  
                    document.getElementById("box").innerHTML="<input type=\"text\" name=\"password\" id=\"input_pass\" placeholder=\"Password\" value="+this.forms.password.value+">";   
                    document.getElementById("click").innerHTML="<a href=\"javascript:hideps()\">Hide password</a>"  
                }  
            }   
            function hideps(){   
                if (this.forms.password.type="text") {  
                    document.getElementById("box").innerHTML="<input type=\"password\" name=\"password\" id=\"input_pass\" placeholder=\"Password\" value="+this.forms.password.value+">";   
                    document.getElementById("click").innerHTML="<a href=\"javascript:showps()\">Show password</a>"  
                }   
            }   
</script>

</body>
</html>
