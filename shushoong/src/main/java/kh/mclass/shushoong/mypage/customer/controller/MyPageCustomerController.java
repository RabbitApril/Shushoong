package kh.mclass.shushoong.mypage.customer.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kh.mclass.shushoong.member.model.domain.MemberDto;
import kh.mclass.shushoong.member.model.repository.MemberRepository;
import kh.mclass.shushoong.mypage.customer.model.repository.MypageCustomerRepository;
import kh.mclass.shushoong.mypage.customer.model.service.MypageCustomerService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/customer")
@RequiredArgsConstructor
public class MyPageCustomerController {
	
	@Autowired
	private MypageCustomerRepository repository;
	
	private final MypageCustomerService service;
	
	// 마이페이지 메인 페이지로 이동
	@GetMapping("/mypage/home")
	public String mypageHome() {
		return "mypage/customer/mypageCustomerHome";
	}
	
	// 비밀번호 확인 페이지로 이동 
	@GetMapping("/check/pwd")
	public String checkPwd() {
		return "mypage/customer/mypageCheckPwd";
	}
	
	@PostMapping("/check/pwd.ajax")
	public boolean checkPwdForm(String userId, String userPwd) {
		MemberDto dto = MemberRepository.
		boolean matches;
	}
	
	// 개인정보 수정 페이지로 이동
	@GetMapping("/my/information")
	public String correctInfoCustomer(Principal principal, ModelMap modelMap) {
		String userId = principal.getName();
		MemberDto dto = repository.selectOne(userId);
		modelMap.addAttribute("dto",dto);
		return "mypage/customer/mypageCorrectInfoCustomer";
	}
	
	// 마이페이지 항공 리스트 페이지로 이동
	@GetMapping("/mypage/reserved/airline/list")
	public String getMethodName() {
		return "/customer/mypage/mypageCustomerReservedAlirlineList";
	}
	
}
