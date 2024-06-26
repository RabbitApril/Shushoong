package kh.mclass.shushoong.mypage.business.model.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kh.mclass.shushoong.member.model.domain.MemberDto;
import kh.mclass.shushoong.mypage.business.model.repository.MypageBusinessRepository;

@Service
public class MypageBusinessService {

	@Autowired
	private MypageBusinessRepository mypageRepository;

	public MemberDto selectOne(String userId) {
		return mypageRepository.selectOne(userId);
	}

	// 비밀번호 체크
	public String pwdChecking(String userId) {
		return mypageRepository.pwdChecking(userId);
	}

	// 비밀번호 재설정
	public int resetPwd(Map<String, Object> paraMap) {
		return mypageRepository.resetPwd(paraMap);
	}
}
