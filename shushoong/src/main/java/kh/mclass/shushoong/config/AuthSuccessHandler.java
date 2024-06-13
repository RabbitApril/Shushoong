package kh.mclass.shushoong.config;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kh.mclass.shushoong.member.model.repository.MemberRepository;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Component
public class AuthSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		super.clearAuthenticationAttributes(request);

		RequestCache requestCache = new HttpSessionRequestCache();
		SavedRequest savedRequest = requestCache.getRequest(request, response);

		if (savedRequest != null) {
			String url = savedRequest.getRedirectUrl();
			if (url == null || url.equals("")) {
				url = "airline/main";
			}
			if (url.contains("/register")) {
				url = "airline/main";
			}
			if (url.contains("/login")) {
				url = "airline/main";
			}
			requestCache.removeRequest(request, response);
			getRedirectStrategy().sendRedirect(request, response, url);
		}
		super.onAuthenticationSuccess(request, response, authentication);
	}
}