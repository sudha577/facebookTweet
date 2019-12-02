<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<link rel="stylesheet" href="/css/tweet.css">

</head>


<body>
	<script type="text/javascript" src="/js/tweet.js"></script>
	<script type="text/javascript"
		src="https://code.jquery.com/jquery-1.7.1.min.js"></script>

	<!-- Top Navigation Bar Code Begin -->
	<div class="topnav">
		<!-- List the Items in the Top Navigation Bar  -->
		<a href="#">Tweet</a> 
		<a href="friendstweet.jsp">Friend's Tweet</a> 
		<a id=toptweet href=toptweet.jsp>Top Tweets</a>

		<div id="fb-root"></div>
		<div align="right">
			<div class="fb-login-button" data-max-rows="1" data-size="large"
				data-button-type="login_with" data-show-faces="false"
				data-auto-logout-link="true" data-use-continue-as="true"
				scope="public_profile,email" onlogin="checkLoginState();"></div>
		</div>
	</div>

	<!-- Top Navigation Bar Code End -->


	<script type="text/javascript">
		callme()
	</script>
	<%
		if (null != request.getParameter("status")) {
			request.setAttribute("status", request.getAttribute("status"));
		}
	%>
	<%-- ${status} --%>
	<input type=hidden id=status value="${status}">
	<br>
	<div align="center">
		<h1>
			<div id="fb-welcome"></div>
		</h1>
		<table>
			<tr>
				<form id="storegae" action="GaeStore" method="get" name="storegae">
					<td>
					<textarea id="text_content" name="text_content"
							class="textarea" placeholder="Enter Tweet Message....."></textarea>
					</td> 
						<input type=hidden id=user_id name=user_id />
					 	<input type=hidden	id=first_name name=first_name /> 
						<input type=hidden id=last_name	name=last_name /> 
						<input type=hidden id=picture name=picture />
					<script>
						console.log(document.getElementById("first_name") + " "
								+ document.getElementById("last_name") + " "
								+ document.getElementById("profile_pic"));
					</script>
					<td><input type="submit" id=submit name=save class="button"
						value="Send Tweet" /></td>
				</form>
			</tr>

			<tr>
				
				<td><input type="button" id="share_tweet" class="button"
					value="Share Tweet Application" /></td>
				<td>
					<form action="getmytweet.jsp" method="GET">
						<input type=hidden id=user_ids name=user_ids /> <br> 
						<input type="submit" class="button" value="View My Tweets"
							name="view_tweet" />
					</form>
				</td>
			</tr>
		</table>
	</div>

	<div align="center">

		<div id="mypopup" class="popup">
			<div class="popup-content">
				<span class="close">&times;</span> <input type="button"
					class="button" value="Post to TimeLine" name="share_tweet"
					onclick=shareDirectTweet() /> <input type="button" class="button"
					value="Send Direct Message" name="send_direct_msg"
					onclick=sendDirectMsg() />
			</div>
		</div>

	</div>


	<script>
		var modal = document.getElementById('mypopup');
		var btn = document.getElementById("share_tweet");
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
		document.getElementById("user_ids").value = getCookie('user_id');
		document.getElementById("user_id").value = getCookie('user_id');
		document.getElementById("first_name").value = getCookie('first_name');
		document.getElementById("first_names").value = getCookie('first_name');
		document.getElementById("last_name").value = getCookie('last_name');
		document.getElementById("picture").value = getCookie('profile_pic');
		document.getElementById("toptweet").href = "toptweet.jsp?name="
				+ getCookie("first_name");
	</script>
</body>
</html>