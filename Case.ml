(*****************************************************************************)
(*                                                                           *)
(*   Vincent Jacquier                                     :::      ::::::::  *)
(*   Jean-Jacques MOIROUX                               :+:      :+:    :+:  *)
(*                                                    +:+ +:+         +:+    *)
(*   By: vjacquie <vjacquie@student.42.fr>          +#+  +:+       +#+       *)
(*   By: jmoiroux <jjmoiroux@gmail.com>           +#+#+#+#+#+   +#+          *)
(*                                                     #+#    #+#            *)
(*   Created: 2015/18/15 by vjacquie jmoiroux         ###   ########.fr      *)
(*                                                                           *)
(*****************************************************************************)

type t = string * string * string * string

let whatPlayerFromInt player =
	if player = '1' then 'X'
	else if player = '2' then 'O'
	else '-'

let whatPlayerFromChar charCheck =
	if charCheck = 'X' then '1'
	else if charCheck = 'O' then '2'
	else '0'

let full_cercle case = match case with
	| (line0, line1, line2, status) -> begin
		String.set line0 0 '/'; String.set line0 2 '_'; String.set line0 4 '\\';
		String.set line1 0 '|'; String.set line1 2 ' '; String.set line1 4 '|';
		String.set line2 0 '\\'; String.set line2 2 '_'; String.set line2 4 '/';
		print_endline "O win a grid !"
	end

let full_cross case = match case with
	| (line0, line1, line2, status) -> begin
		String.set line0 0 '\\'; String.set line0 2 ' '; String.set line0 4 '/';
		String.set line1 0 ' '; String.set line1 2 'X'; String.set line1 4 ' ';
		String.set line2 0 '/'; String.set line2 2 ' '; String.set line2 4 '\\';
		print_endline "X win a grid !"
	end

let check_hori case = match case with
	| (line0, line1, line2, status) -> begin
		if (line0.[0] = line0.[2]) && (line0.[0] = line0.[4]) && (line0.[0] <> '-') then whatPlayerFromChar line0.[0]
		else if (line1.[0] = line1.[2]) && (line1.[0] = line1.[4]) && (line1.[0] <> '-') then whatPlayerFromChar line1.[0]
		else if (line2.[0] = line2.[2]) && (line2.[0] = line2.[4]) && (line2.[0] <> '-') then whatPlayerFromChar line2.[0]
		else '0'
	end

let checkDraw ((line0, line1, line2, d):t) =
	let rec loop iter =
		if iter = 9 then true
		else begin
			let tabY = 
				if iter > 5 then 2
				else if iter > 2 then 1
				else 0
			in
			let tabX = (iter mod 3) in
			if tabY = 0 && line0.[tabX * 2] = '-' then false
			else if tabY = 1 && line1.[tabX * 2] = '-' then false
			else if tabY = 2 && line2.[tabX * 2] = '-' then false
			else loop (iter + 1)
		end
	in 
	loop 0

let check_vert case = match case with
	| (line0, line1, line2, status) -> begin
		if (line0.[0] = line1.[0]) && (line0.[0] = line2.[0]) && (line0.[0] <> '-') then whatPlayerFromChar line0.[0]
		else if (line0.[2] = line1.[2]) && (line0.[2] = line2.[2]) && (line0.[2] <> '-') then whatPlayerFromChar line0.[2]
		else if (line0.[4] = line1.[4]) && (line0.[4] = line2.[4]) && (line0.[4] <> '-') then whatPlayerFromChar line0.[4]
		else '0'
	end

let check_diag case = match case with
	| (line0, line1, line2, status) -> begin
		if (line0.[0] = line1.[2]) && (line0.[0] = line2.[4]) && (line0.[0] <> '-') then whatPlayerFromChar line0.[0]
		else if (line2.[0] = line1.[2]) && (line2.[0] = line0.[4]) && (line2.[0] <> '-') then whatPlayerFromChar line2.[0]
		else '0'
	end

let check (case:t) player = match case with
	| (line0, line1, line2, status) -> begin
			if check_hori case <> '0' then status.[0] <- check_hori case
			else if check_vert case <> '0' then status.[0] <- check_vert case
			else if check_diag case <> '0' then status.[0] <- check_diag case
			else if checkDraw case = true then status.[0] <- player
			else status.[0] <- '0'
	end

let line_print (case:t) y = match case with
	| (line0, line1, line2, status) -> begin
		if y = 0 then print_string line0
		else if y = 1 then print_string line1
		else if y = 2 then print_string line2
		else invalid_arg "Case::line_print y wrong argument"
	end

let winnerCase case = match case with
		| (a, b, c, d) when d = "0" -> print_string ""
		| (a, b, c, d) when d = "1" -> full_cross case
		| (a, b, c, d) when d = "2" -> full_cercle case
		| _ -> print_string ""



			

let putchar (nbr:int) (case:t) (player:char) =
	let char_to_case = whatPlayerFromInt player in
	let tabY = begin
		if nbr > 5 then 2
		else if nbr > 2 then 1
		else 0
	end
	in
	let tabX = (nbr mod 3) in 
		match case with
			| (line0, line1, line2, status) when status <> "0" -> false
			| (line0, line1, line2, status) -> begin
				if tabY = 0 then begin
					if line0.[tabX * 2] <> '-' then false
					else begin
						String.set line0 (tabX * 2) char_to_case;
						check case player;
						winnerCase case;
						true
					end
				end
				else if tabY = 1 then begin
					if line1.[tabX * 2] <> '-' then false
					else begin
						String.set line1 (tabX * 2) char_to_case;
						check case player;
						winnerCase case;
						true
					end
				end
				else if tabY = 2 then begin
					if line2.[tabX * 2] <> '-' then false
					else begin
						String.set line2 (tabX * 2) char_to_case;
						check case player;
						winnerCase case;
						true
					end
				end
				else invalid_arg "Case::putchar case wrong y"
			end
