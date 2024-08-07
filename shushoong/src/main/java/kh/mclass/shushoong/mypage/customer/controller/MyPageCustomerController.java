package kh.mclass.shushoong.mypage.customer.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;
import kh.mclass.shushoong.hotel.model.domain.HotelDtoRes;
import kh.mclass.shushoong.member.model.domain.MemberDto;
import kh.mclass.shushoong.mypage.customer.model.domain.ReviewDto;
import kh.mclass.shushoong.mypage.customer.model.repository.MypageCustomerRepository;
import kh.mclass.shushoong.mypage.customer.model.service.MypageCustomerService;
import kh.mclass.shushoong.servicecenter.model.service.OnlineQnAService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/customer")
@RequiredArgsConstructor
@Slf4j
public class MyPageCustomerController {

	@Autowired
	private MypageCustomerRepository repository;

	// PortOne
	@Value("${portone.store.key}")
	private String storeId;

	@Value("${portone.channel.key}")
	private String channelKey;

	@Value("${portone.secret.key}")
	private String secretKey;

	@Autowired
	private Gson gson;

	@Autowired
	private OnlineQnAService QnAservice;

	private final MypageCustomerService service;
	private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

	int pageSize = 5;
	int pageBlockSize = 3;
	int currentPageNum = 1;

	// 마이페이지 메인 페이지로 이동
	@GetMapping("/mypage/home")
	public String mypageHome(Model model, String category, String keyword, String questCat, Authentication auth) {
		String userId = auth.getName();
		int totalCount = QnAservice.selectTotalCount(userId, category, keyword, questCat);
		model.addAttribute("result",
				QnAservice.selectAllList(pageSize, pageBlockSize, currentPageNum, userId, category, keyword, questCat));
		int totalPageCount = (totalCount % pageSize == 0) ? totalCount / pageSize : totalCount / pageSize + 1;
		int startPageNum = (currentPageNum % pageBlockSize == 0)
				? ((currentPageNum / pageBlockSize) - 1) * pageBlockSize + 1
				: ((currentPageNum / pageBlockSize)) * pageBlockSize + 1;
		int endPageNum = (startPageNum + pageBlockSize > totalPageCount) ? totalPageCount
				: startPageNum + pageBlockSize - 1;

		model.addAttribute("currentPageNum", currentPageNum);
		model.addAttribute("totalPageCount", totalPageCount);
		model.addAttribute("startPageNum", startPageNum);
		model.addAttribute("endPageNum", endPageNum);
		return "mypage/customer/mypageCustomerHome";
	}

	// 비밀번호 확인 페이지로 이동
	@GetMapping("/check/password")
	public String checkPwd() {
		return "mypage/customer/mypageCheckPwd";
	}

	@PostMapping(value = "/check/password")
	public String PwdChecking(@RequestParam("userPwd") String userPwd, Authentication auth, RedirectAttributes rttr) {

		User user = (User) auth.getPrincipal();
		String member = repository.pwdChecking(user.getUsername());
		if (encoder.matches(userPwd, member)) {
			log.info("password 확인 완료");
			return "redirect:/customer/my/information";
		} else {
			rttr.addFlashAttribute("message", "오류");
			return "redirect:/customer/check/password";
		}
	}

	// 개인정보 수정 페이지로 이동
	@GetMapping("/my/information")
	public String correctInfoCustomer(Principal principal, ModelMap modelMap) {
		String userId = principal.getName();
		MemberDto dto = repository.selectOne(userId);
		modelMap.addAttribute("dto", dto);
		return "mypage/customer/mypageCorrectInfoCustomer";
	}

	@PostMapping("/changeInfo.ajax")
	public String changePwd(@RequestParam("userPwd") String userPwd, @RequestParam("emailReceive") String emailReceive,
			@RequestParam("msgReceive") String msgReceive, Principal principal, RedirectAttributes rttr,
			@RequestParam Map<String, Object> paramMap) {

		String userId = principal.getName();
		paramMap.put("userPwd", encoder.encode(userPwd));
		paramMap.put("userId", userId);
		paramMap.put("emailReceive", emailReceive);
		paramMap.put("msgReceive", msgReceive);

		int result = service.resetInfo(paramMap);

		String message = null;

		if (result > 0) {
			message = "변경사항이 변경되었습니다.";

		} else {
			message = "변경에 실패했습니다.";
		}

		rttr.addFlashAttribute("message", message);
		return "redirect:/customer/my/information";
	}
	
	// 회원 탈퇴
	@GetMapping("/secessionAccount.hidden")
	public String secessionAccount(HttpSession session, Principal principal) {
		String userId = principal.getName();
		String message = null;
		
		int result = repository.secessionAccount(userId);
		try {
			if(result > 0) {
				return "redirect:/logout";
			}
		} catch (Exception e) {
			return "redirect:/mypage/customer/mypageCorrectInfoCustomer";
		}
		return "redirect:/home";
	}

	// 마이페이지 호텔 리스트 페이지로 이동
	@GetMapping("/mypage/reserved/hotel/list")
	public String hotelReserve(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		// security로 userId 불러오기
		String userId = authentication.getName();
		model.addAttribute("userId", userId);
		model.addAttribute("reserveList", service.selectReservedHotelList(userId));
		// service에서 불러온 값 변수 선언 따로 안하고 바로 model 에 넣기
		model.addAttribute("cancelList", service.selectCancelHotelList(userId));

		return "mypage/customer/mypageCustomerReservedHotelList";
	}

	// 마이페이지 호텔 예매내역 하나 선택
	@GetMapping("/mypage/reserved/hotel/{userId}/{hotelReserveCode}")
	public String selectOneHotel(Model model, @PathVariable("userId") String userId,
			@PathVariable("hotelReserveCode") String hotelReserveCode) {
		// input 태그에 있는 name 여기에 씀
		// getParameter 역할
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String loginId = authentication.getName();
		if (!userId.equals(loginId)) {
			return "home";

		} else {

			Map<String, Object> reservationDetails = service.selectOneReservedHotel(userId, hotelReserveCode);

			if (reservationDetails != null && !reservationDetails.isEmpty()) {
				// 'requestSum' 값을 Double로 변환하여 사용
				Integer requestNum = ((BigDecimal) reservationDetails.get("REQUEST_SUM")).intValue();
				// oracle 데이터베이스의 NUMBER(3) 타입은 최대 3자리의 정수를 표현할 수 있는 숫자형 데이터 타입이라서
				// Java에서는 이를 BigDecimal 또는 Integer로 처리해야함

				String requestSumStr = "";
				// String requestSumStr = requestNum.toString(); -> 이렇게 쓰니까 당연히 숫자가 들어가지...

				if ((requestNum & 1) != 0) {
					requestSumStr += "싱글, ";
				}
				if ((requestNum & 2) != 0) {
					requestSumStr += "트윈, ";
				}
				if ((requestNum & 4) != 0) {
					requestSumStr += "더블, ";
				}
				if ((requestNum & 8) != 0) {
					requestSumStr += "금연실, ";
				}
				if ((requestNum & 16) != 0) {
					requestSumStr += "흡연실, ";
				}
				if ((requestNum & 32) != 0) {
					requestSumStr += "고층, ";
				}

				if (!requestSumStr.isEmpty()) {
					// requestDesc 가 비어있지 않다면..

					requestSumStr = requestSumStr.substring(0, requestSumStr.length() - 2);
					// 0 은 index를 나타냄
					// -2 는 쉼표와 공백 제거하기 위해 빼기
				}

				model.addAttribute("requestDesc", requestSumStr);

				// 예약 날짜 문자열
				String checkOut = (String) reservationDetails.get("RESERVE_CHECK_OUT");
				String checkOutDate = checkOut.replace("년", "").replace("월", "").replace("일", "");
				
				// 날짜 형식 정의
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				try {
				
					// 현재 날짜 가져오기
					LocalDate currentDate1 = LocalDate.now();
					String currentDate = currentDate1.format(formatter);

					model.addAttribute("checkOutDate", checkOutDate);
					model.addAttribute("currentDate", currentDate);

				} catch (DateTimeParseException e) {
					e.printStackTrace();
					System.out.println("Invalid date format.");
				}

			} else {

			}
			model.addAttribute("reserveList", reservationDetails);
			model.addAttribute("userId", loginId);

			return "mypage/customer/mypageCustomerReservedHotel";

		}
	}
	
	//리뷰 작성 ajax
	@ResponseBody
	@PostMapping("/mypage/submit/review.ajax")
	public int submitReview(Model model, @RequestBody ReviewDto dto, Authentication auth) {
		System.out.println("==================" + dto.toString());
		dto.setUserId(auth.getName());
		int result = service.insertReview(dto);
		if(result > 0) {
			service.updateReviewAvailable(dto.getHotelReserveCode());
		}
		
		return result;
	}

	// 마이페이지 호텔 취소내역 하나 선택
	@GetMapping("/mypage/cancel/hotel/{userId}/{hotelReserveCode}")
	public String selectOneCancelHotel(Model model, @PathVariable("userId") String userId,
			@PathVariable("hotelReserveCode") String hotelReserveCode) {
		// input 태그에 있는 name 여기에 씀
		// getParameter 역할
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String loginId = authentication.getName();
		if (!userId.equals(loginId)) {
			return "home";

		} else {

			Map<String, Object> reservationDetails = service.selectOneCancelHotel(userId, hotelReserveCode);

			if (reservationDetails != null && !reservationDetails.isEmpty()) {
				// 'requestSum' 값을 Double로 변환하여 사용
				Integer requestNum = ((BigDecimal) reservationDetails.get("REQUEST_SUM")).intValue();
				// oracle 데이터베이스의 NUMBER(3) 타입은 최대 3자리의 정수를 표현할 수 있는 숫자형 데이터 타입이라서
				// Java에서는 이를 BigDecimal 또는 Integer로 처리해야함

				String requestSumStr = "";
				// String requestSumStr = requestNum.toString(); -> 이렇게 쓰니까 당연히 숫자가 들어가지...

				if ((requestNum & 1) != 0) {
					requestSumStr += "싱글, ";
				}
				if ((requestNum & 2) != 0) {
					requestSumStr += "트윈, ";
				}
				if ((requestNum & 4) != 0) {
					requestSumStr += "더블, ";
				}
				if ((requestNum & 8) != 0) {
					requestSumStr += "금연실, ";
				}
				if ((requestNum & 16) != 0) {
					requestSumStr += "흡연실, ";
				}
				if ((requestNum & 32) != 0) {
					requestSumStr += "고층, ";
				}

				if (!requestSumStr.isEmpty()) {
					// requestDesc 가 비어있지 않다면..

					requestSumStr = requestSumStr.substring(0, requestSumStr.length() - 2);
					// 0 은 index를 나타냄
					// -2 는 쉼표와 공백 제거하기 위해 빼기
				}

				model.addAttribute("requestDesc", requestSumStr);
			} else {

			}

			model.addAttribute("cancelList", service.selectOneCancelHotel(userId, hotelReserveCode));

			return "mypage/customer/mypageCustomerCancelHotel";

		}
	}

	// 호텔 예약취소하기
	@PostMapping("/mypage/reserved/hotel/cancel")
	@ResponseBody
	public int cancelHotel(String paymentId, String hotelCode, String roomAtt, String roomCap, String roomCat, String room) throws IOException, InterruptedException {
		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("reason", "고객 요청으로 결제 취소");

		// 결제 취소 API 호출
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("https://api.portone.io/payments/" + paymentId + "/cancel"))
				.header("Content-Type", "application/json").header("Authorization", "PortOne " + secretKey)
				.method("POST", HttpRequest.BodyPublishers.ofString(gson.toJson(requestBody))).build();
		HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

		Map<String, Object> responseMap = gson.fromJson(response.body(), Map.class);

		System.out.println(response.body() + "=================");

		Map<String, Object> cancellation = gson.fromJson(gson.toJson(responseMap.get("cancellation")), Map.class);

		String status = (String) cancellation.get("status");
		int result;
		// 결제 취소 완료 상태면 결제 내역 테이블에서 삭제
		if (status != null) {
			if (status.equals("SUCCEEDED")) {
				result = service.cancelHotelReserve(paymentId);
				service.increaseRoom(hotelCode, room, roomCat, roomCap, roomAtt);
				return result;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}

	// 마이페이지 항공 리스트 페이지로 이동
	@GetMapping("/mypage/reserved/airline/list")
	public String selectReservedAirlineList(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		// security로 userId 불러오기
		String userId = authentication.getName();
		model.addAttribute("userId", userId);
		model.addAttribute("reserveList", service.selectReservedAirlineList(userId));
		// service에서 불러온 값 변수 선언 따로 안하고 바로 model 에 넣기
		model.addAttribute("cancelList", service.selectCancelAirlineList(userId));

		return "mypage/customer/mypageCustomerReservedAirlineList";
	}

	// 마이페이지 항공 예약 상세페이지 이동
	@GetMapping("/mypage/reserved/airline/{userId}/{airlineCode}/{airlineReserveCode}")
	public String selectOneAirline(Model model, @PathVariable("userId") String userId,
			@PathVariable("airlineCode") String airlineCode, @PathVariable("airlineReserveCode") String airlineReserveCode) {
		// input 태그에 있는 name 여기에 씀
		// getParameter 역할
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String loginId = authentication.getName();
		if (!userId.equals(loginId)) {
			return "home";

		} else {

			List<Map<String, Object>> reservationDetailList = service.selectOneReservedAirline(userId, airlineCode, airlineReserveCode);

			for (Map<String, Object> reservationDetail : reservationDetailList) {
				if (reservationDetail.containsKey("DEPART_DATE")) {
					Object depart = reservationDetail.get("DEPART_DATE");
					
					try {
						// 문자열을 LocalDate 객체로 변환
						if (depart instanceof String) {
				            String departString = (String) depart;

				            // 첫 번째 날짜만 추출
				            String firstDateStr = departString.split(",")[0].trim();

				            // 문자열을 LocalDate로 변환
				            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년MM월dd일");
				            LocalDate departDate = LocalDate.parse(firstDateStr, formatter);

				            // 현재 날짜 가져오기
				            LocalDate currentDate = LocalDate.now();
				            // 결과 출력
				            
				            model.addAttribute("departDate", departDate);
				            model.addAttribute("currentDate", currentDate);

				        } else {
				            System.out.println("DEPART_DATE 값이 문자열이 아닙니다.");
				        }


					} catch (DateTimeParseException e) {
						e.printStackTrace();
						System.out.println("Invalid date format.");
					}
					
				} else {
					System.out.println("DEPART_DATE 키가 없습니다.");
				}

				if (reservationDetailList != null && !reservationDetailList.isEmpty()) {

					model.addAttribute("reservationDetailList", service.selectOneReservedAirline(userId, airlineCode, airlineReserveCode));
				}
			}
		}
		return "mypage/customer/mypageCustomerReservedAirline";
	}

	//항공 예약취소하기
	@PostMapping("/mypage/reserved/airline/cancel")
	@ResponseBody
	public int cancelAirline(String paymentId) throws IOException, InterruptedException {
		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("reason", "고객 요청으로 결제 취소");

		// 결제 취소 API 호출
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create("https://api.portone.io/payments/" + paymentId + "/cancel"))
				.header("Content-Type", "application/json").header("Authorization", "PortOne " + secretKey)
				.method("POST", HttpRequest.BodyPublishers.ofString(gson.toJson(requestBody))).build();
		HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

		Map<String, Object> responseMap = gson.fromJson(response.body(), Map.class);

		System.out.println(response.body() + "=================");

		Map<String, Object> cancellation = gson.fromJson(gson.toJson(responseMap.get("cancellation")), Map.class);

		String status = (String) cancellation.get("status");
		int result;
		// 결제 취소 완료 상태면 결제 내역 테이블에서 삭제
		if (status != null) {
			if (status.equals("SUCCEEDED")) {
				result = service.cancelAirlineReserve(paymentId);
				return result;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}	
	
	// 마이페이지 항공 취소내역 하나 선택
	@GetMapping("/mypage/cancel/airline/{userId}/{airlineCode}/{airlineReserveCode}")
	public String selectOneCancelAirline(Model model, @PathVariable("userId") String userId,
			@PathVariable("airlineReserveCode") String airlineReserveCode,  @PathVariable("airlineCode") String airlineCode) {
		// input 태그에 있는 name 여기에 씀
		// getParameter 역할
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String loginId = authentication.getName();
		if (!userId.equals(loginId)) {
			return "home";

		} else {

			List<Map<String, Object>> reservationDetails = service.selectOneCancelAirline(userId, airlineCode, airlineReserveCode);

			model.addAttribute("cancelList", service.selectOneCancelAirline(userId, airlineCode, airlineReserveCode));

			return "mypage/customer/mypageCustomerCancelAirline";

		}
	}

	
	
	@GetMapping("/mypage/hotel/interested")
	public String interestedPage(Principal principal, Model md) {
		String userId = principal.getName();

		List<HotelDtoRes> hotelList = service.selectListInterestedHotel(userId);
		md.addAttribute("hotelList", hotelList);

		return "mypage/customer/myapgeHotelLike";
	}

	@ResponseBody
	@PostMapping("/mypage/hotel/interested/delete")
	public int postMethodName(@RequestParam String hotelCode) {
		int result = 0;
		result = service.deleteHotelLiked(hotelCode);

		System.out.println("result : " + result);
		return result;
	}

	@GetMapping("/mypage/hotel/review")
	public String hotelReview(Principal principal, Model md) {
		String userId = principal.getName();
		List<Map<String, String>> hotelReviewList = service.selectListHotelReview(userId);
		md.addAttribute("hotelReviewList", hotelReviewList);

		return "mypage/customer/mypageHotelReview";
	}

	@ResponseBody
	@PostMapping("/mypage/hotel/reivew/delete")
	public int deleteOneHotelReview(String hotelResCode, Principal principal) {
		int result = 0;
		String userId = principal.getName();
		log.info("hotelResCode{" + hotelResCode + "}userId{" + userId + "}");
		result = service.deleteOneHotelReview(userId, hotelResCode);

		return result;
	}

}
