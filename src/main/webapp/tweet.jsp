<%--This is first Tweet page of the app where user can generate tweet, 
post it on own timeline, friends timeline and also send it as a tweet as a message.
user can also view all tweets made so far, and delete them as well.
--%>
<%@page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@page import="com.google.appengine.api.datastore.Query"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<html>
<head>
<link rel="stylesheet" href="/css/tweet.css">
<script type="text/javascript" src="/js/tweet.js"></script>
<script> callme();</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
<!-- Google Analytics code for client side tracking-->
	
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-153765665-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-153765665-1');
</script>
</head>
<body>
<form id="storegae" action="GaeStore" method="get" name="storegae"  >
<div class="topnav">
		<a href="tweet.jsp">TWEET</a> 
		<a href="friendsTweets.jsp">FRIENDS</a> 
		<a id=toptweet href="toptweet.jsp">TOP-TWEET</a>
		<div id="fb-root"></div>
		<div align="center">
			<div class="fb-login-button" data-max-rows="1" data-size="large"
				data-button-type="login_with" data-show-faces="false"
				data-auto-logout-link="true" data-use-continue-as="true"
				scope="public_profile,email" onlogin="checkLoginState();"></div>
		</div>
	</div>
<td><textarea type="text" id="text_content" name="text_content" class="textarea"
							placeholder="TYPE HERE" ></textarea></td>
<input type=hidden id=user_id name= user_id />
<input type=hidden id=first_name name=first_name  />
<input type=hidden id=last_name name=last_name  />
<input type=hidden id=picture name=picture  />
<td><input type="submit" id=submit name=save class="button"   />
</form>

<form action="tweet.jsp" method="GET">
<input type=hidden id=user_ids name=user_ids  />
<hr>
<h1 align="center">Here are my tweets!!</h1> 
</form>

</body>
</html>
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
</table>
<hr>
<script type="text/javascript">
function shareMyTweet( message){ //method to share users tweet
	//  ui() is used to trigger Facebook created UI share dialog to share tweet on timeline
	FB.ui({method: 'share',
		href: message,
		//quote: document.getElementById('text_content').value,
		},function(response){
		if (!response || response.error) //response when error occurs while posting
		{
			console.log(response.error);
			alert('Posting error occured');
		}
	});
}
function sendmyDirectTweet(message){ //method to share tweet directly as message
	//  ui() is used to trigger Facebook created UI share dialog to share tweet to friend as message
	FB.ui({method:  'send',
		  link: message,});
	console.log(document.getElementById("status")); // log the status of posting by id
}
</script>
<%	/*Servlet class -> create new tweet and store them*/
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
if (request.getParameter("u_id") != null) {
	Entity s = ds.get(KeyFactory.createKey("tweet", Long.parseLong(request.getParameter("u_id"))));
	//s.getKey();
	ds.delete(s.getKey());
	out.println("tweet ID:" + Long.parseLong(request.getParameter("u_id")) + " is deleted from GAE");
}
	Entity e = new Entity("tweet");
	Query q = new Query("tweet");
	String uid=null;
	String pic=null;
	Cookie cookie = null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	for (int i = 0; i < cookies.length; i++) {
	if(cookies[i].getName().compareTo("picture")==0){
		pic=cookies[i].getValue();
	}
	if(cookies[i].getName().compareTo("user_id")==0){
		uid=cookies[i].getValue();
	}
	}
	PreparedQuery pq = ds.prepare(q);
	int count = 0;
	for (Entity result : pq.asIterable()) {
		if (result.getProperty("user_id") != null
				&& ((result.getProperty("user_id")).equals(uid))) {
			//out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
			String first_name = (String) result.getProperty("first_name");
			count++;
			String lastName = (String) result.getProperty("last_name");
			String user_id = (String) result.getProperty("user_id");
			//String picture = (String) result.getProperty("picture");
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

<table>
	<tr>
		<td><div style="height: 100px; width: 100px">
				<img src="<%=pic%>"/></div>
		<td>
		<td>User: <%=first_name + " " + lastName%>
		</td>
	</tr>
	<div>
		<tr>
			<td><br>
			<br>Status: <%=status%></td>
		</tr>
	<tr>
		<td>Posted at: <%=time%></td>
	</tr>
	<tr>
		<td>#Visited: <%=visited_count%></td>
	</tr>
	<tr>
		<form action="tweet.jsp" action="GET">
			<input type=hidden name=user_id id=user_id value=<%=user_id%> /> 
			<input type=hidden name=u_id id=u_id value=<%=id%> />
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
	</tr>
	<hr>

<%
	Entity s = ds.get(KeyFactory.createKey("tweet", id));
			s.setProperty("visited_count", visited_count + 1);
			ds.put(s);
			//  count++;
		}
	}
%>