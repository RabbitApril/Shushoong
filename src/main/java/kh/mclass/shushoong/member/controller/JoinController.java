package kh.mclass.shushoong.member.controller;

import org.springframework.context.annotation.PropertySource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kh.mclass.shushoong.member.model.domain.MemberDto;
import kh.mclass.shushoong.member.model.service.MemberSecurityService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
//@PropertySource("classpath:/keyfiles/apikey.properties")
public class JoinController {
	
	private final MemberSecurityService memberservice;
	
	
	// 회원가입 메인 페이지로 이동
	@GetMapping("join")
	public String join() {
		return "member/joinHome";
	}

	// 일반유저 가입 페이지로 이동
	@GetMapping("join/customer")
	public String joinCustomer() {
		return "member/userJoin";
	}

	// 사업자회원 가입 페이지로 이동
	@GetMapping("join/business")
	public String joinBusiness() {
		return "member/businessJoin";
	}
	
//	@PostMapping("join/customer")
//	@ResponseBody
//	public int customerJoin(MemberDto memberdto) {
//		try {
//			
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//	
//	@PostMapping("join/business")
//	@ResponseBody
//	public int businessJoin(MemberDto memberdto) {
//		try {
//			
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
}
