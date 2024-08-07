package kh.mclass.shushoong.config;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Iterator;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kh.mclass.shushoong.member.model.service.MemberService;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class UserAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

	private final MemberService memberService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		String error;
		if (exception instanceof BadCredentialsException) {
			error = "BadCredentialsException";
		} else if (exception instanceof InternalAuthenticationServiceException) {
			error = "InternalAuthenticationServiceException";
		} else if (exception instanceof UsernameNotFoundException) {
			error = "UsernameNotFoundException";
		} else if (exception instanceof AuthenticationException) {
			error = "AuthenticationException";
		} else if (exception instanceof LockedException){
			error = "LockedException";
		} else {
			error = "others";
		}
		error = URLEncoder.encode(error, "UTF-8");
		setDefaultFailureUrl("/login?error=true&exception=" + error);

		super.onAuthenticationFailure(request, response, exception);
	}
}
