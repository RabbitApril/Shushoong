package kh.mclass.shushoong.member.login.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import kh.mclass.shushoong.member.model.domain.MemberDto;
import kh.mclass.shushoong.member.model.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
public class LoginController {
	
	@Autowired
	private final MemberService memberservice;
	
	// 관리자 로그인
	@GetMapping("/manager/login")
	public String managerLogin() {
		return "mypage/admin/adminLogin";
	}
	
	@PostMapping("/auth/check.ajax")
	public int authCheck() {
		int cnt = 0;
		return cnt;
	}
	
	// 로그인 페이지로 이동
	@GetMapping("/login")
	public String login(@RequestParam(value = "error", required = false)String error, 
						Model model, String remember,  HttpServletResponse response,
						Principal principal) {
		
		String message="";
		
		if(error != null) {
			switch(error) {
			case "BadCredentialsException":
				message = "이메일 또는 비밀번호가 맞지 않습니다. 다시 확인해주세요.";
				break;
			case "InternalAuthenticationServiceException":
				message = "시스템 문제로 인해 요청을 처리할 수 없습니다. 관리자에게 문의해주세요.";
				break;
			case "UsernameNotFoundException":
				message = "계정이 존재하지 않습니다. 회원가입 진행 후 로그인 해주세요.";
				break;
			case "AuthenticationException":
				message = "탈퇴 처리된 회원입니다. 관리자에게 문의해주세요.";
				break;
			default:
				message = "알 수 없는 이유로 로그인에 실패하였습니다. 관리자에게 문의해주세요.";
				break;
			}
		}
		
		if (remember == null) {
            remember = "";
        }
		
		if (remember.equals("on")) {
            Cookie cookie = new Cookie("remember", principal.getName());
            response.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("remember", "");
            response.addCookie(cookie);
        }
		
        model.addAttribute("message", message);
		return "member/login";
	}
}
