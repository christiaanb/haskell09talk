\RequirePackage{atbegshi}
\documentclass[empty]{caes_presentation}
%include talk.fmt
\include{preamble}

\title{\clash{}}
\subtitle{From Haskell To Hardware}
\author{Christiaan Baaij \& Matthijs Kooijman}
\committee{Supervisor: Jan Kuper}
\date{September 3, 2009}

\begin{document}

\frame{\titlepage}
\note[itemize]{
\item Small tour: what can we describe in \clash{}
\item Quick real demo
}

\include{introduction}
\include{PolyAlu}
\include{demo}
\include{reducer}
\include{howdoesitwork}
\include{summary}

\end{document}
