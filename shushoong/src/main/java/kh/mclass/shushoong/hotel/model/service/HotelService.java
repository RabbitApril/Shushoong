 package kh.mclass.shushoong.hotel.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kh.mclass.shushoong.hotel.model.domain.HotelPic;
import kh.mclass.shushoong.hotel.model.domain.HotelReviewDtoRes;
import kh.mclass.shushoong.hotel.model.domain.HotelReviewOverallDtoRes;
import kh.mclass.shushoong.hotel.model.domain.HotelDtoRes;
import kh.mclass.shushoong.hotel.model.domain.HotelFacilityDtoRes;
import kh.mclass.shushoong.hotel.model.domain.HotelRoomDto;
import kh.mclass.shushoong.hotel.model.domain.HotelSearchDtoRes;
import kh.mclass.shushoong.hotel.model.repository.HotelRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class HotelService {

	private final HotelRepository hotelRepository;
	
	public List<HotelDtoRes> selectAllHotelList(String loc, String people, String keyword, String maxPrice, String sortBy, String sortTo) {
		return hotelRepository.selectAllHotelList(loc, people, keyword, maxPrice, sortBy, sortTo);
	}
	
	public Integer selectMaxRoomlPrice(String loc, String people, String keyword) {
		return hotelRepository.selectMaxRoomlPrice(loc, people, keyword);
	}
	
	public List<HotelPic> selectPicList(String hotelCode) {
		return hotelRepository.selectHotelPicList(hotelCode);
	}
	
	public List<HotelRoomDto> selectRoomList(String hotelCode) {
		return hotelRepository.selectRoomList(hotelCode);
	}
	
	//호텔 상세정보
	public List<HotelSearchDtoRes> selectHotelSearchList(String hotelCode) {
		return hotelRepository.selectHotelSearchList(hotelCode);
	}
	
	//해당 호텔 편의시설 정보 불러오기
	public List<HotelFacilityDtoRes> selectHotelFacility(String hotelCode) {
		return hotelRepository.selectHotelFacility(hotelCode);
	}

	//해당 호텔 리뷰 작성된거 불러오기
	public List<HotelReviewDtoRes> selectReviewAll(String hotelCode) {
		return hotelRepository.selectReviewAll(hotelCode);
	}
	
	//해당 호텔 리뷰 작성된거 불러오기
	public List<HotelReviewOverallDtoRes> selectReviewOverall(String hotelCode) {
		return hotelRepository.selectReviewOverall(hotelCode);
	}

}
