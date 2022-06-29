import requests
from bs4 import BeautifulSoup
import pymysql
import time
import re


def get_soup(url):
    res = requests.get(url)
    if res.status_code == 200:
        return BeautifulSoup(res.text, 'html.parser')


def mv_info_spec_crawling(mv_info_spec):
    genres = nations = opening_date = playing_time = domestic_mv_rate = oversea_mv_rate = None
    mv_info_spec_class = mv_info_spec.select("dt")
    mv_info_spec_info = mv_info_spec.select("dd")
    for i in range(len(mv_info_spec_class)):
        spec_class = mv_info_spec_class[i].text.replace("()", "")
        if spec_class == "개요":
            scope_span = mv_info_spec_info[i].select("span")
            for scope in scope_span:
                # genre
                if "genre" in str(scope):
                    genres = scope.text.replace("\n", "").replace("\r", "").replace("\t", "").split(", ")
                # nation
                elif "nation" in str(scope):
                    nations = scope.text.replace("\n", "").replace("\r", "").replace("\t", "").split(", ")
                # opening_date
                elif ('year' in str(scope)) or ('day' in str(scope)):
                    opening_date = scope.text.replace("\n", "").replace("\r", "").replace("\t", "").replace(" ", "")[
                                   :-2].replace(".", "-")
                    if len(opening_date) == 4:
                        opening_date += '-12-31'
                    elif len(opening_date) == 7:
                        opening_date += '-30'
                # playing time
                else:
                    playing_time = int(scope.text.replace("분 ", ""))
        elif spec_class == "등급":
            # movie_rate (국내 등급: domestic_mv_rate / 해외 등급: oversea_mv_rate)
            mv_rate = str(mv_info_spec_info[i])
            if ('국내' in mv_rate) and ('해외' in mv_rate):
                domestic_mv_rate = mv_info_spec_info[i].select("a")[0].text
                oversea_mv_rate = mv_info_spec_info[i].select("a")[1].text
            elif '국내' in mv_rate:
                domestic_mv_rate = mv_info_spec_info[i].select("a")[0].text
            elif '해외' in mv_rate:
                oversea_mv_rate = mv_info_spec_info[i].select("a")[0].text

    return domestic_mv_rate, oversea_mv_rate, playing_time, opening_date, genres, nations


def open_db():
    conn = pymysql.connect(host='localhost',
                           user='root',
                           password='wjdgusxor99',
                           db='movie_ver2',
                           charset='utf8mb4')
    cur = conn.cursor(pymysql.cursors.DictCursor)

    return conn, cur


def close_db(conn, cur):
    cur.close()
    conn.close()


def insert_movie_database():
    conn_movie, cur_movie = open_db()
    conn_genre, cur_genre = open_db()
    conn_nation, cur_nation = open_db()
    conn_photo, cur_photo = open_db()
    conn_media, cur_media = open_db()
    conn_netizen_point, cur_netizen_point = open_db()
    conn_journalist_point, cur_journalist_point = open_db()
    conn_actor, cur_actor = open_db()
    conn_casting, cur_casting = open_db()
    conn_director, cur_director = open_db()
    conn_direct, cur_direct = open_db()
    conn_review, cur_review = open_db()
    conn_script, cur_script = open_db()

    insert_movie_sql = """
    insert ignore into movie(mv_code, title, domestic_mv_rate, oversea_mv_rate,
        netizen_audience_score, netizen_score, journalist_score,
        playing_time, opening_date, review_cnt_up_300, image_src, s_title, s_text)
    values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    insert_genre_sql = """
    insert ignore into genre(mv_code, genre)
    values(%s, %s)
    """

    insert_nation_sql = """
    insert ignore into nation(mv_code, nation)
    values(%s, %s)
    """

    insert_photo_sql = """
    insert ignore into photo(mv_code, photo_src)
    values(%s, %s)
    """

    insert_media_sql = """
    insert ignore into media(mv_code, media_src, media_type, media_title, media_posted_date)
    values(%s, %s, %s, %s, %s)
    """

    insert_netizen_point_sql = """
    insert ignore into netizen_point(mv_code, n_score, audience_check, n_name, n_text, n_posted_date, n_like, n_dislike)
    values(%s, %s, %s, %s, %s, %s, %s, %s)
    """

    insert_journalist_point_sql = """
    insert ignore into journalist_point(mv_code, j_score, j_name, j_text)
    values(%s, %s, %s, %s)
    """

    insert_script_sql = """
    insert ignore into script(mv_code, a_role, a_name, s_script, s_explanation, n_name, s_good, s_posted_date)
    values(%s, %s, %s, %s, %s, %s, %s, %s)
    """

    insert_actor_sql = """
    insert ignore into actor(a_code, a_name, a_src)
    values(%s, %s, %s)
    """

    insert_casting_sql = """
    insert ignore into casting(mv_code, a_code, a_part, a_role)
    values(%s, %s, %s, %s)
    """

    insert_director_sql = """
    insert ignore into director(d_code, d_name, d_src)
    values(%s, %s, %s)
    """

    insert_direct_sql = """
    insert ignore into direct(mv_code, d_code)
    values(%s, %s)
    """

    insert_review_sql = """
    insert ignore into review(mv_code, r_code, r_score, r_name, r_title, r_posted_date, r_view, r_good, r_text)
    values(%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    buffer_movie = []
    buffer_genre = []
    buffer_nation = []
    buffer_photo = []
    buffer_media = []
    buffer_netizen_point = []
    buffer_journalist_point = []
    buffer_script = []

    buffer_actor = []
    buffer_casting = []

    buffer_director = []
    buffer_direct = []

    buffer_review = []

    count = 1
    start_time = time.time()

    # 최종
    opening_years = list(range(2022, 1989, -1))

    for opening_year in opening_years:
        page = 1
        while 1:
            soup = get_soup(f'https://movie.naver.com/movie/sdb/browsing/bmovie.naver?open={opening_year}&page={page}')
            content = soup.select_one('#old_content')
            directory_list = content.select('.directory_list > li')

            # 해당 페이지에 있는 영화 개수
            len_mv_per_page = len(directory_list)

            # 영화 접근
            basic_movie_address = 'https://movie.naver.com'

            # 해당 페이지 당 영화 세트
            m_phase = 1

            for i in range(len_mv_per_page):
                # movie
                mv_code = title = domestic_mv_rate = oversea_mv_rate = netizen_audience_score = netizen_score = None
                journalist_score = playing_time = opening_date = image_src = None
                # story
                s_title = s_text = None
                # review_comment
                c_name = c_text = c_posted_date = c_like = c_dislike = None

                movie_href = basic_movie_address + directory_list[i].select_one("a").attrs['href']
                movie_data = get_soup(movie_href)

                mv_info_area = movie_data.select_one('#content .mv_info_area')

                if mv_info_area is None:
                    continue

                # -----movie / genre / nation -----
                # mv_code
                mv_code = int(movie_href.split('=')[-1])

                ### mv_info
                mv_info = mv_info_area.select_one('.mv_info')
                # title
                title = mv_info.select_one('.h_movie a').text

                ## mv_main_score -> 관람객 평점 / 기자, 평론가 평점 / 네티즌 평점
                mv_main_score = mv_info.select_one('.main_score')
                if mv_main_score:
                    # netizen_audience_score: 관람객 평점 / journalist_score: 기자, 평론가 평점 / netizen_score
                    netizen_audience_score_em = mv_main_score.select('.ntz_score .star_score em')
                    netizen_audience_score = ''
                    for em in netizen_audience_score_em:
                        netizen_audience_score += em.text
                    if netizen_audience_score:
                        netizen_audience_score = float(netizen_audience_score)
                    else:
                        netizen_audience_score = 0.0

                    netizen_score_em = mv_main_score.select('#pointNetizenPersentBasic')
                    netizen_score = ''
                    for em in netizen_score_em:
                        netizen_score += em.text
                    if netizen_score:
                        netizen_score = float(netizen_score)
                    else:
                        netizen_score = 0.0

                    journalist_score_em = mv_main_score.select('.spc .star_score em')
                    journalist_score = ''
                    for em in journalist_score_em:
                        journalist_score += em.text
                    if journalist_score:
                        journalist_score = float(journalist_score)
                    else:
                        journalist_score = 0.0

                ## mv_info_spec -> 개요 / 감독 / 출연 / 등급
                mv_info_spec = mv_info.select_one('.info_spec')
                domestic_mv_rate, oversea_mv_rate, playing_time, opening_date, genres, nations = mv_info_spec_crawling(
                    mv_info_spec)

                # review_cnt_up_300
                soup = get_soup(f'https://movie.naver.com/movie/bi/mi/point.naver?code={mv_code}')
                review_cnt_up_300 = False
                review_cnt = soup.select_one('#afterPointArea .user_count em')
                if review_cnt:
                    if int(review_cnt.text.replace(',', '')) >= 300:
                        review_cnt_up_300 = True

                # img
                image_src = mv_info_area.select_one('.poster img').attrs['src']

                # -----story-----
                story_data = movie_data.select_one('.story_area')
                if story_data:
                    if story_data.select_one('.h_tx_story'):
                        s_title = story_data.select_one('.h_tx_story').text
                    if story_data.select_one('p.con_tx'):
                        s_text = story_data.select_one('p.con_tx').text  # .replace("\r\xa0", " ").replace('\xa0', ' ')

                t_movie = (mv_code, title, domestic_mv_rate, oversea_mv_rate, netizen_audience_score, netizen_score,
                           journalist_score, playing_time, opening_date, review_cnt_up_300, image_src, s_title, s_text)
                buffer_movie.append(t_movie)

                if genres:
                    for genre in genres:
                        buffer_genre.append((mv_code, genre))
                if nations:
                    for nation in nations:
                        buffer_nation.append((mv_code, nation))

                # -----photo-----
                photo_page = 1
                photo_href = movie_href.replace('basic', 'photo')

                while 1:
                    photo_page_href = photo_href + f'&page={photo_page}#movieEndTabMenu'
                    photo_page_data = get_soup(photo_page_href).select_one('.obj_section2')

                    photo_data_list = photo_page_data.select('.gallery_group li img')
                    for photo_data in photo_data_list:
                        photo_src = None
                        photo_src = photo_data.attrs['src']
                        t_photo = (mv_code, photo_src)
                        buffer_photo.append(t_photo)

                    if photo_page_data.select_one('.paging') is None:
                        break

                    if '다음' in str(photo_page_data.select_one('.paging').text):
                        photo_page += 1
                    else:
                        break

                # -----media-----
                media_href = movie_href.replace('basic', 'media')
                media_data = get_soup(media_href)
                media_data = media_data.select('.ifr_module > div')

                for media_types in media_data:
                    media_type = None
                    media_list = media_types.select('.video_thumb > li')
                    media_type = media_types.select_one('.title_area em').text
                    for media in media_list:
                        media_title = media_src = media_posted_date = None
                        media_title = media.select('p')[0].text
                        media_posted_date = media.select('p')[1].text.replace('.', '-')
                        media_href = basic_movie_address + media.select_one('a').attrs['href']
                        media_src = basic_movie_address + get_soup(media_href).select_one("._videoPlayer").attrs['src']
                        t_media = (mv_code, media_src, media_type, media_title, media_posted_date)
                        buffer_media.append(t_media)

                # -----netizen_point-----
                netizen_point_page = 1
                movie_point_href = movie_href.replace('basic', 'point')

                # n_point_cnt : 네티즌 평점 개수 (50개 이하로 조절)
                n_point_cnt = 1

                while 1:
                    netizen_point_data = get_soup(movie_point_href).select_one('#pointAfterListIframe')
                    netizen_point_data = get_soup(
                        basic_movie_address + netizen_point_data.attrs['src'] + f'&page={netizen_point_page}')
                    netizen_point_list = netizen_point_data.select('.score_result li')

                    for i in range(len(netizen_point_list)):
                        n_name = n_text = n_posted_date = n_like = n_dislike = None
                        n_score = 0
                        audience_check = False
                        if netizen_point_list[i].select_one('em'):
                            n_score = int(netizen_point_list[i].select_one('em').text)

                            netizen_point_reple = netizen_point_list[i].select_one('.score_reple')

                            if (netizen_point_reple.select_one('dt span') is None) or (
                            not netizen_point_reple.select('dt em')) or (
                                    netizen_point_reple.select_one(f'#_filtered_ment_{i}') is None):
                                continue
                            if netizen_point_list[i].select('.btn_area strong') is None:
                                continue

                            if netizen_point_reple.select_one('.ico_viewer'):
                                audience_check = True
                            n_text = netizen_point_reple.select_one(
                                f'#_filtered_ment_{i}').text  # .replace('\r', '').replace('\n', '').replace('\t', '')
                            n_name = netizen_point_reple.select_one('dt span').text
                            n_posted_date = netizen_point_reple.select('dt em')[-1].text.replace('.', '-')
                            n_like = int(netizen_point_list[i].select('.btn_area strong')[0].text)
                            n_dislike = int(netizen_point_list[i].select('.btn_area strong')[1].text)

                            t_netizen_point = (
                            mv_code, n_score, audience_check, n_name, n_text, n_posted_date, n_like, n_dislike)
                            buffer_netizen_point.append(t_netizen_point)
                        if n_point_cnt == 50:
                            break
                        n_point_cnt += 1

                    if (n_point_cnt == 50) or (netizen_point_data.select_one('.paging') is None):
                        break

                    if '다음' in str(netizen_point_data.select_one('.paging').text):
                        netizen_point_page += 1
                    else:
                        break

                # -----journalist_point-----
                journlist_point_data = get_soup(movie_point_href).select_one('.score_special')

                if journlist_point_data:
                    reporter_point_data = journlist_point_data.select_one('.reporter')
                    if reporter_point_data:
                        reporter_point_data_list = reporter_point_data.select('li')
                        for reporter in reporter_point_data_list:
                            j_name = j_text = None
                            j_score = 0
                            if reporter.select_one('.p_review a'):
                                j_name = reporter.select_one('.p_review a').text
                            if reporter.select_one('.re_score_grp em'):
                                j_score = int(reporter.select_one('.re_score_grp em').text.split(".")[0])
                            if reporter.select_one('.tx_report'):
                                j_text = reporter.select_one('.tx_report').text
                            t_journalist_point = (mv_code, j_score, j_name, j_text)
                            buffer_journalist_point.append(t_journalist_point)

                    score140_point_data = journlist_point_data.select_one('.score140')
                    if score140_point_data:
                        score140_point_data_list = score140_point_data.select('li')
                        for score140 in score140_point_data_list:
                            j_name = j_text = None
                            j_score = 0
                            if score140.select_one('.star_score em'):
                                j_score = int(score140.select_one('.star_score em').text.split(".")[0])
                            if score140.select_one('.score_reple p'):
                                j_text = score140.select_one('.score_reple p').text
                            if score140.select_one('.score_reple dd'):
                                j_name = score140.select_one(".score_reple dd").text.replace('\n', '').replace('\t',
                                                                                                               '').replace(
                                    '| ', '')
                            t_journalist_point = (mv_code, j_score, j_name, j_text)
                            buffer_journalist_point.append(t_journalist_point)

                # -----script-----
                script_page = 1

                # script_cnt : 명대사 개수 (50개 이하로 조절)
                script_cnt = 1

                while 1:
                    script_href = movie_href.replace('basic', 'script') + f'&order=best&nid=&page={script_page}'
                    script_data = get_soup(script_href)

                    script_list = script_data.select('#iframeDiv ul.lines li')

                    for script in script_list:
                        a_role = a_name = s_script = s_explanation = n_name = s_posted_date = None
                        s_good = 0

                        s_script = script.select_one('p.one_line').text
                        # s_script = re.sub('[^ A-Za-z0-9가-힣]+', '', s_script)
                        if script.select_one('p.char_part span'):
                            a_role = script.select_one('p.char_part span').text
                        if script.select_one('p.char_part a'):
                            a_name = script.select_one('p.char_part a').text
                        if script.select_one('p.line_desc'):
                            if script.select_one('p.line_desc').text != '':
                                s_explanation = script.select_one('p.line_desc').text
                        if script.select_one('a.user_id'):
                            n_name = script.select_one('a.user_id').text
                        if script.select('.w_recomm em'):
                            s_good = int(script.select('.w_recomm em')[-1].text)
                        if script.select_one('em.date'):
                            s_posted_date = script.select_one('em.date').text.replace('.', '-')

                        t_script = (mv_code, a_role, a_name, s_script, s_explanation, n_name, s_good, s_posted_date)
                        buffer_script.append(t_script)
                        if script_cnt == 50:
                            break
                        script_cnt += 1

                    if (script_cnt == 50) or (script_data.select_one('.paging') is None):
                        break

                    if '다음' in str(script_data.select_one('.paging').text):
                        script_page += 1
                    else:
                        break

                # -----actor / director-----
                movie_detail_href = movie_href.replace('basic', 'detail')
                movie_detail_data = get_soup(movie_detail_href).select_one('.section_group_frst')

                # actor
                actor_data = movie_detail_data.select('ul.lst_people > li')
                for actor in actor_data:
                    a_code = a_name = a_src = a_part = a_role = None
                    if actor.select_one('.p_thumb a'):
                        a_code = int(actor.select_one('.p_thumb a').attrs['href'].split('=')[-1])
                        a_name = actor.select_one('.p_thumb a').attrs['title']
                        a_src = actor.select_one('.p_thumb img').attrs['src']
                        if actor.select_one('.p_info .p_part'):
                            a_part = actor.select_one(".p_info .p_part").text
                        if actor.select_one('.p_info .pe_cmt'):
                            a_role = actor.select_one('.p_info .pe_cmt').text.replace('\n', '').replace(' 역', '')
                        t_actor = (a_code, a_name, a_src)
                        buffer_actor.append(t_actor)
                        t_casting = (mv_code, a_code, a_part, a_role)
                        buffer_casting.append(t_casting)

                # director
                director_data = movie_detail_data.select('.dir_obj')
                for director in director_data:
                    d_code = d_name = d_src = None
                    if director.select_one('.thumb_dir a'):
                        d_code = int(director.select_one('.thumb_dir a').attrs['href'].split('=')[-1])
                        d_src = director.select_one('.thumb_dir img').attrs['src']
                        d_name = director.select_one('.thumb_dir img').attrs['alt']
                        t_director = (d_code, d_name, d_src)
                        buffer_director.append(t_director)
                        t_direct = (mv_code, d_code)
                        buffer_direct.append(t_direct)


                # -----review-----
                review_page = 1

                # review_cnt : 리뷰 개수 (20개 이하로 조절)
                review_cnt = 1

                while 1:
                    movie_review_href = movie_href.replace('basic', 'review') + f'&page={review_page}'
                    movie_review_data = get_soup(movie_review_href).select_one('.ifr_area .review')
                    movie_review_list = movie_review_data.select('.rvw_list_area li')
                    for movie_review in movie_review_list:
                        r_code = r_score = r_name = r_title = r_posted_date = r_views = r_goods = r_text = None
                        if movie_review.select_one('a').attrs.get('onclick', None):
                            r_code = int(movie_review.select_one('a').attrs['onclick'].split('(')[-1][:-1])
                            review_href = movie_review_href.replace('review',
                                                                    'reviewread') + f'&nid={r_code}&order=#tab'

                            review_data = get_soup(review_href).select_one('.center_obj .review')
                            r_score = ''
                            r_scores = review_data.select('.top_behavior em')
                            if r_scores:
                                for score in r_scores:
                                    r_score += score.text
                                r_score = int(r_score)
                            else:
                                r_score = None
                            if review_data.select_one('.top_behavior .h_lst_tx'):
                                r_title = review_data.select_one('.top_behavior .h_lst_tx').text
                            if review_data.select_one('.top_behavior .wrt_date'):
                                r_posted_date = review_data.select_one('.top_behavior .wrt_date').text.replace('.', '-')
                            if review_data.select('.board_title li em'):
                                r_name = review_data.select('.board_title li em')[-1].text
                            if review_data.select('.user_tx_info span em'):
                                r_view = int(review_data.select('.user_tx_info span em')[0].text)
                            if review_data.select('.user_tx_info span em'):
                                r_good = int(review_data.select('.user_tx_info span em')[1].text)
                            if review_data.select_one('.user_tx_area'):
                                r_text = review_data.select_one('.user_tx_area').text.replace('\n', ' ')
                                r_text = re.sub('[^ A-Za-z0-9가-힣]+', '', r_text)

                            t_review = (mv_code, r_code, r_score, r_name, r_title, r_posted_date, r_view, r_good, r_text)
                            buffer_review.append(t_review)

                        if review_cnt == 20:
                            break
                        review_cnt += 1

                    if (review_cnt == 20) or (movie_review_data.select_one('.paging') is None):
                        break

                    if '다음' in str(movie_review_data.select_one('.paging').text):
                        review_page += 1
                    else:
                        break

                if count % 10 == 0:
                    end_time = time.time()
                    print(
                        f'year: {opening_year}, page/m_phase: {page}/{m_phase}, count: {count}, time: {end_time - start_time}')
                    m_phase += 1
                    start_time = time.time()

                if count % 100 == 0:
                    cur_movie.executemany(insert_movie_sql, buffer_movie)
                    conn_movie.commit()
                    cur_genre.executemany(insert_genre_sql, buffer_genre)
                    conn_genre.commit()
                    cur_nation.executemany(insert_nation_sql, buffer_nation)
                    conn_nation.commit()
                    cur_photo.executemany(insert_photo_sql, buffer_photo)
                    conn_photo.commit()
                    cur_media.executemany(insert_media_sql, buffer_media)
                    conn_media.commit()
                    cur_netizen_point.executemany(insert_netizen_point_sql, buffer_netizen_point)
                    conn_netizen_point.commit()
                    cur_journalist_point.executemany(insert_journalist_point_sql, buffer_journalist_point)
                    conn_journalist_point.commit()
                    cur_script.executemany(insert_script_sql, buffer_script)
                    conn_script.commit()
                    cur_actor.executemany(insert_actor_sql, buffer_actor)
                    conn_actor.commit()
                    cur_casting.executemany(insert_casting_sql, buffer_casting)
                    conn_casting.commit()
                    cur_director.executemany(insert_director_sql, buffer_director)
                    conn_director.commit()
                    cur_direct.executemany(insert_direct_sql, buffer_direct)
                    conn_direct.commit()
                    cur_review.executemany(insert_review_sql, buffer_review)
                    conn_review.commit()

                    time.sleep(2)

                    buffer_movie = []
                    buffer_genre = []
                    buffer_nation = []
                    buffer_photo = []
                    buffer_media = []
                    buffer_netizen_point = []
                    buffer_journalist_point = []
                    buffer_script = []
                    buffer_actor = []
                    buffer_casting = []
                    buffer_director = []
                    buffer_direct = []
                    buffer_review = []
                count += 1

            page_num = content.select_one('.pagenavigation')
            if page_num is None:
                break

            if '다음' in page_num.text:
                page += 1
            else:
                break

        cur_movie.executemany(insert_movie_sql, buffer_movie)
        conn_movie.commit()
        cur_genre.executemany(insert_genre_sql, buffer_genre)
        conn_genre.commit()
        cur_nation.executemany(insert_nation_sql, buffer_nation)
        conn_nation.commit()
        cur_photo.executemany(insert_photo_sql, buffer_photo)
        conn_photo.commit()
        cur_media.executemany(insert_media_sql, buffer_media)
        conn_media.commit()
        cur_netizen_point.executemany(insert_netizen_point_sql, buffer_netizen_point)
        conn_netizen_point.commit()
        cur_journalist_point.executemany(insert_journalist_point_sql, buffer_journalist_point)
        conn_journalist_point.commit()
        cur_script.executemany(insert_script_sql, buffer_script)
        conn_script.commit()
        cur_actor.executemany(insert_actor_sql, buffer_actor)
        conn_actor.commit()
        cur_casting.executemany(insert_casting_sql, buffer_casting)
        conn_casting.commit()
        cur_director.executemany(insert_director_sql, buffer_director)
        conn_director.commit()
        cur_direct.executemany(insert_direct_sql, buffer_direct)
        conn_direct.commit()
        cur_review.executemany(insert_review_sql, buffer_review)
        conn_review.commit()

        buffer_movie = []
        buffer_genre = []
        buffer_nation = []
        buffer_photo = []
        buffer_media = []
        buffer_netizen_point = []
        buffer_journalist_point = []
        buffer_script = []
        buffer_actor = []
        buffer_casting = []
        buffer_director = []
        buffer_direct = []
        buffer_review = []

    close_db(conn_movie, cur_movie)
    close_db(conn_genre, cur_genre)
    close_db(conn_nation, cur_nation)
    close_db(conn_photo, cur_photo)
    close_db(conn_media, cur_media)
    close_db(conn_netizen_point, cur_netizen_point)
    close_db(conn_journalist_point, cur_journalist_point)
    close_db(conn_script, cur_script)
    close_db(conn_actor, cur_actor)
    close_db(conn_casting, cur_casting)
    close_db(conn_director, cur_director)
    close_db(conn_direct, cur_direct)
    close_db(conn_review, cur_review)


if __name__ == '__main__':
    insert_movie_database()
