<%@page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@page import="com.google.appengine.api.datastore.Query"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<html>
<head>
<link rel="stylesheet" href="/css/tweet.css">
<script type="text/javascript" src="/js/tweet.js"></script>
<script> callme();</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
<form id="storegae" action="GaeStore" method="get" name="storegae"  >
<div class="topnav">
		<a href="tweet.jsp">TWEET</a> 
		<a href="friendstweet.jsp">FRIENDS</a> 
		<a id=toptweet href="toptweet.jsp">TOP-TWEET</a>
	   <a href="#about"></a>
		<div id="fb-root"></div>
		<div align="center">
			<div class="fb-login-button" data-max-rows="1" data-size="large"
				data-button-type="login_with" data-show-faces="false"
				data-auto-logout-link="true" data-use-continue-as="true"
				scope="public_profile,email" onlogin="checkLoginState();"></div>
		</div>
	</div>
<td><textarea id="text_content" name="text_content" class="textarea"
							placeholder="TYPE HERE" ></textarea></td>
<input type=hidden id=user_id name= user_id />
<input type=hidden id=first_name name=first_name  />
<input type=hidden id=last_name name=last_name  />
<input type=hidden id=picture name=picture  />

<td><input type="submit" id=submit name=save class="button"   />
</form>
<br><input type="button"  id="create_tweet" class="button"  onclick=modalOpen(this) value="Create Tweet!!"  />

<form action="getmytweet.jsp" method="GET">
<input type=hidden id=user_ids name=user_ids  />
<br><input type="submit"  class="button" value="Display the Tweets " name="view_tweet"   />
</form>
<div align="center">
			<div id="mypopup" class="popup">
				<div class="popup-content">
					<span class="close">&times;</span> 
					<script type="text/javascript">message=""</script>
					<button type="button"class="button" onclick=shareMyTweet(message) > Share Tweet</button> 
					<button type="button" class="button" name="send_direct_msg" onclick=sendmyDirectTweet(message) >Send Direct Message</button>
				</div>
			</div>
		</div>
</td>
</tr>
</table>
</div>

<div align="center">

<div id="mypopup" class="popup">
<div  class="popup-content">
<span class="close">&times;</span>

</div>
</div>

</div>

<script>

console.log(document.getElementById("first_name")+" "+document.getElementById("last_name")+" "+document.getElementById("picture"));
</script>
<script>

var modal = document.getElementById('mypopup');
var btn = document.getElementById("create_tweet");
var span = document.getElementsByClassName("close")[0];
btn.onclick = function() {
    modal.style.display = "block";
};
span.onclick = function() {
    modal.style.display = "none";
};
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
};
document.getElementById("user_ids").value       = getCookie('user_id');
document.getElementById("user_id").value       = getCookie('user_id');
document.getElementById("first_name").value = getCookie('first_name');
document.getElementById("first_names").value = getCookie('first_name');
document.getElementById("last_name").value  = getCookie('last_name');
document.getElementById("picture").value    = getCookie('picture');
document.getElementById("toptweet").href="toptweet.jsp?name="+getCookie("first_name");

</script>


	
	
<%
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	Entity e = new Entity("tweet");
	Query q = new Query("tweet");
	PreparedQuery pq= ds.prepare(q);

	int count = 0;
	for (Entity result : pq.asIterable()) {
		if (result.getProperty("user_id") != null
				&& ((result.getProperty("user_id")).equals(request.getParameter("user_ids")))) {
			
			String first_name = (String) result.getProperty("first_name");
			count++;
			String lastName = (String) result.getProperty("last_name");
			String user_id = (String) result.getProperty("user_id");
			String picture = (String) result.getProperty("profile_pic");
			String status = (String) result.getProperty("status");
			Long id = (Long) result.getKey().getId();
			String time = (String) result.getProperty("timestamp");
			Long visited_count = (Long) ((result.getProperty("visited_count")));
			StringBuffer sb = new StringBuffer();
			String url = request.getRequestURL().toString();
			String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
					+ request.getContextPath() + "/";
			sb.append(baseURL + "direct_tweet.jsp?id=" + id);
%>
<div style="height: 100px; width: 100px">
				<img src='" + result.getProperty("picture.url") + "'></div>


		<form action="getmytweet.jsp" action="GET">
			<input type=hidden name=user_id id=user_id value=<%=user_id%> /> <input
				type=hidden name=u_id id=u_id value=<%=id%> />
			<td><button name="Delete" type="submit" class="button"
					value=Delete />Delete</button></td>
		</form>
		<div align="center">
			<div id="mypopup" class="popup">
				<div class="popup-content">
					<span class="close">&times;</span> 
					<script type="text/javascript">message="<%= sb  %>"</script>
					<button type="button"
						class="button" 
						onclick=shareMyTweet(message) > Share Tweet</button> 
					<button type="button" class="button"
						 name="send_direct_msg"
						onclick=sendmyDirectTweet(message) >Send Direct Message</button>
				</div>
			</div>
		</div>
		<td><button name="Share" type="button" class="button" id=share
				value=<%=sb%>  onclick=modalOpen(this) />share</td>
	
	<script type="text/javascript">
	function modalOpen(obj){
		console.log("inside"+obj.value);
	var modal = document.getElementById('mypopup');
	var btn = obj;
	var span = document.getElementsByClassName("close")[0];
	modal.style.display = "block";
	span.onclick = function() {
		modal.style.display = "none";
	};
	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	};
	}
	</script>
	</div>

<script type="text/javascript">

function shareMyTweet( message){
	FB.ui({method: 'share',
		href: message,
		//quote: document.getElementById('text_content').value,
		},function(response){
		if (!response || response.error)
		{
			console.log(response.error);
			alert('Posting error occured');
		}
	});
}

function sendmyDirectTweet(message){
	FB.ui({method:  'send',
		  link: message,});
	console.log(document.getElementById("status"));
}
</script>
<%
	
		}
	}
	
%>
	
	
</body>
</html>







