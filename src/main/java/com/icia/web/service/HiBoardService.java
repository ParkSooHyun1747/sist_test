package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.common.util.FileUtil;
import com.icia.web.dao.HiBoardDao;
import com.icia.web.model.HiBoard;
import com.icia.web.model.HiBoardFile;

//서비스는 비지니스 로직 구현

@Service("hiBoardService")

public class HiBoardService 
{
	private static Logger logger = LoggerFactory.getLogger(HiBoardService.class);
	
	//파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private HiBoardDao hiBoardDao;
	
	//게시판 등록
	//Propagation.REQUIRED : 트랜잭션(일이 끝나는 범위를 정하는 것)이 있으면 그 트랜잭션에서 실행, 없으면 새로운 트랜잭션을 실행(기본설정)
	//@Transactional : commit, rollbak 개념(db단과 프로그램단에서 사용할 수 있음)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardInsert(HiBoard hiBoard) throws Exception
	{
		int count = 0;
		count = hiBoardDao.boardInsert(hiBoard);  //1)
		
		//한건이라도 인서트 진행됐고, 객체 생성이 하나라도 됐음
		if(count > 0 && hiBoard.getHiBoardFile() != null) 
		{
			HiBoardFile hiBaordFile = hiBoard.getHiBoardFile();
			hiBaordFile.setHiBbsSeq(hiBoard.getHiBbsSeq());
			hiBaordFile.setFileSeq((short)1); //1로 하드코딩 된 이유, 게시물 1개당 첨부파일 1개만 가능할거라서
			
			hiBoardDao.boardFileInsert(hiBaordFile); //2)까지 다 끝내야 commit //안되면 rollback
			
			/*
			 * 위 로직을 아래와 같이 변경 가능(객체 생성 없이)
			hiBoard.getHiBoardFile().setHiBbsSeq(hiBoard.getHiBbsSeq());
			hiBoard.getHiBoardFile().setFileSeq((short)1);
			
			hiBoardDao.boardFileInsert(hiBoard.getHiBaordFile());
			*/
			
		}
		
		return count;
	}
	
	//게시판 등록2
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor = Exception.class)
	public int boardInsert2(HiBoard hiBoard) throws Exception
	{
		int count = 0;
		//여기서는 try~catch문 안탈거임 컨트롤러에서 탈거임
		count = hiBoardDao.boardInsert(hiBoard);
		
		if(count > 0 && hiBoard.getHiBoardFile() != null) 
		{
			hiBoard.getHiBoardFile().setHiBbsSeq(hiBoard.getHiBbsSeq());
			hiBoard.getHiBoardFile().setFileSeq((short)1);
			
			hiBoardDao.boardFileInsert(hiBoard.getHiBoardFile());
		}
		
		return count;
	}
	
	//게시물 리스트
	public List<HiBoard> boardList(HiBoard hiBoard)
	{
		List<HiBoard> list = null;
		
		try
		{
			list = hiBoardDao.boardList(hiBoard);
		}
		catch (Exception e)
		{
			logger.error("[HiBoardService] boardList Exception", e);
		}
		
		return list;
	}
	
	//총 게시물 수
	public long boadListCount(HiBoard hiBoard) 
	{
		long count = 0;
		
		try
		{
			count = hiBoardDao.boardListCount(hiBoard);
		}
		catch(Exception e) 
		{
			logger.error("[HiBoardService] boadListCount Exception", e);
		}
		
		
		return count;
	}
	
	//게시물 조회
	public HiBoard boardSelect(long hiBbsSeq) 
	{
		HiBoard hiBoard = null;
		
		try 
		{
			hiBoard = hiBoardDao.boardSelect(hiBbsSeq);
		}
		catch (Exception e) 
		{
			logger.error("[HiBoardService] boardSelect Exception", e);
		}
		
		return hiBoard;
	}
	
	//게시물 첨부파일 조회
	public HiBoardFile boardFileSelect(long hiBbsSeq) 
	{
		HiBoardFile hiBoardFile = null;
		
		try 
		{
			hiBoardFile = hiBoardDao.boardFileSelect(hiBbsSeq);
		}
		catch(Exception e) 
		{
			logger.error("[HiBoardService] boardFileSelect Exception", e);
		}
		
		return hiBoardFile;
	}
	
	//조회수는 단독으로 서비스에 넣지 않을거임
	//어떤 서비스가 호출되면서 그 안에서 조회수가 증가하기 때문임 그래서 그냥 콜만 할거임
	
	//게시물 조회(첨부파일 포함, 조회수 증가도 포함), select 안한다는 의미
	public HiBoard boardView(long hiBbsSeq) 
	{
		HiBoard hiBoard = null;
		
		try 
		{
			hiBoard = hiBoardDao.boardSelect(hiBbsSeq);
			
			if(hiBoard != null) 
			{
				//조회수 증가
				hiBoardDao.boardReadCntPlus(hiBbsSeq);
				
				HiBoardFile hiBoardFile = hiBoardDao.boardFileSelect(hiBbsSeq);
				
				if(hiBoardFile != null) 
				{
					hiBoard.setHiBoardFile(hiBoardFile);
				}
			}
		}
		catch(Exception e) 
		{
			logger.error("[HiBoardService] boardView Exception", e);
		}
		
		return hiBoard;
	}
	
	//게시물 답글 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardReplyInsert(HiBoard hiBoard) throws Exception
	{
		int count = 0;
		
		hiBoardDao.boardGroupOrderUpdate(hiBoard);
		count = hiBoardDao.boardReplyInsert(hiBoard); //답글에 대한 인서트
		
		//게시물 정상 등록 되고 나면 첨부파일이 존재한지 확인하고 존재하면 첨부파일도 등록
		if(count > 0 && hiBoard.getHiBoardFile() != null) 
		{
			HiBoardFile hiBoardFile = hiBoard.getHiBoardFile();
			hiBoardFile.setHiBbsSeq(hiBoard.getHiBbsSeq());
			hiBoardFile.setFileSeq((short)1); //얘 MAX로 어쩌고 저쩌고
			
			hiBoardDao.boardFileInsert(hiBoardFile); //hiBoardDao.boardFileInsert(hiBoard.getHiBoardFile());
		}
		
		return count;
	}
	
	//게시물 수정폼 조회(첨부파일 포함), 보드뷰는 못씀, 조회수가 포함되어 있기 땨문
	public HiBoard boardViewUpdate(long hiBbsSeq) 
	{
		HiBoard hiBoard = new HiBoard();
		
		try 
		{
			hiBoard = hiBoardDao.boardSelect(hiBbsSeq);
			
			if(hiBoard != null) 
			{
				HiBoardFile hiBoardFile = hiBoardDao.boardFileSelect(hiBbsSeq);
				
				if(hiBoardFile != null) 
				{
					hiBoard.setHiBoardFile(hiBoardFile);
				}
			}
		}
		catch (Exception e) 
		{
			logger.error("[HiBoardService] boardViewUpdate Exception", e);
		}
		
		return hiBoard;
	}
	
	//게시물 수정(업데이트는 딜리트 인서트의 개념)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardUpdate(HiBoard hiBoard) throws Exception
	{
		//처리 건수 받음
		int count = hiBoardDao.boardUpdate(hiBoard);
		
		//첨부파일 있으면(컨트롤러에서 첨부파일 있음)
		if(count > 0 && hiBoard.getHiBoardFile() != null) 
		{
			//첨부파일 정보 셀렉트해서 읽어와
			HiBoardFile delHiBoardFile = hiBoardDao.boardFileSelect(hiBoard.getHiBbsSeq());
			
			//기존 파일이 있으면 삭제
			if(delHiBoardFile != null) 
			{
				//어느 디렉토리에 있는 어떤 파일을 삭제할 것이냐
				//업로드된 파일부터 먼저 삭제됨(풀 경로 다쓰고 디렉토리에 나타나있는 코드 읽어오고 처음 글을 읽어올 때 유효 아이디값 )
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delHiBoardFile.getFileName());
				//하이보트 테이블에 인서트 되어있는 파일 삭제
				hiBoardDao.boardFileDelete(hiBoard.getHiBbsSeq());
			}
			
			//if문 자체가 첨부파일 있다는 거니까 객체생성
			HiBoardFile hiBoardFile = hiBoard.getHiBoardFile();
			hiBoardFile.setHiBbsSeq(hiBoard.getHiBbsSeq());
			hiBoardFile.setFileSeq((short)1);
			
			//실제로 하이보드 테이블에 인서트
			hiBoardDao.boardFileInsert(hiBoard.getHiBoardFile());
		}
		
		return count;
	}
	
	//게시물 삭제시 답변글 수 조회
	public int boardAnswersCount(long hiBbsSeq) 
	{
		int count = 0;
		
		try 
		{
			count = hiBoardDao.boardAnswersCount(hiBbsSeq);
			//컨트롤러로 갈거임
		}
		catch(Exception e)
		{
			logger.error("[HiBoardService] boardAnswersCount Exception", e);
		}
		
		return count;
	}
	
	//게시물 삭제(첨부파일 있으면 함께 삭제)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardDelete(long hiBbsSeq) throws Exception
	{
		int count = 0;
		
		//같은 클래스 내에 있는 인스턴스 메서드라서 따로 선언 필요없음
		//boardViewUpdate에는 게시물 조회와 첨부파일 조회 메서드가 있음
		HiBoard hiBoard = boardViewUpdate(hiBbsSeq);
		
		//데이터가 있을 때
		if(hiBoard != null) 
		{
			count = hiBoardDao.boardDelete(hiBbsSeq);
			
			if(count > 0) 
			{
				//시작 주소값만 바라봄
				HiBoardFile hiBoardFile = hiBoard.getHiBoardFile();
				
				//첨부파일이 있냐
				if(hiBoardFile != null) 
				{
					//실제 삭제되었음
					if(hiBoardDao.boardFileDelete(hiBbsSeq) > 0) 
					{
						//첨부파일 관련 데이터들 삭제
						FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + hiBoardFile.getFileName());
					}
				}
			}
		}
		
		return count;
	}
}
