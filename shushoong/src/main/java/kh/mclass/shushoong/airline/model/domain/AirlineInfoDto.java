package kh.mclass.shushoong.airline.model.domain;

import org.springframework.stereotype.Component;

import lombok.Data;
import lombok.Getter;

@Data
@Component
public class AirlineInfoDto {
	private int ticketType; //편도=1 왕복=2
	private int child;//소아 인수
	private int baby;//유아 인수
	private String seatGrade;//좌석 등급 1=일등급 2=비즈니스 3=이코노미
	private int seatTotal;
	private int seatReserved; // 
	
	private String airlineCode; // 운항 코드
	private String flightNo; // 항공편명
	private String departLoc;  // 출발 지역
	private String arrivalLoc; // 도착 지역
	private String departTime; // 출발 시간
	private String arrivalTime; // 도착 시간
	private String departDate; // 출발 일자
	private String arrivalDate; // 도착 일자
	private String airlineName; // 항공사 명
	private String airlineImg; // 항공사 로고
	private String domesticFlights; // 국내선 = D /국제선 = I
	private Integer viaCount; // 경로 횟수
	private int seatSpare; // 잔여 좌석
	private String seatPrice; // 티켓 값
	private String flightTime; // 비행 시간
	// 항공 목록 정렬
	private String departTimeLeft;
	private String departTimeRight;
	private String arrivalTimeLeft;
	private String arrivalTimeRight;
	private String viaType;
	private String selectType;
	private boolean plusDate; // 항공 날짜 계산 (하루 넘어가는것)
	
	private String reserveCode;//예약코드 (PK 탑승자 정보와 연결 경로)
	
	private int seatRandomPrice; // 왕복 오는편 가격
}
